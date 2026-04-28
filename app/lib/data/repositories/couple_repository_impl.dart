import 'dart:math';

import 'package:cupid_date/domain/repositories/couple_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CoupleRepositoryImpl implements CoupleRepository {
  CoupleRepositoryImpl(this._supabase);
  final SupabaseClient _supabase;

  String _generateCode() {
    final rand = Random.secure();
    return List.generate(6, (_) => rand.nextInt(10).toString()).join();
  }

  @override
  Future<String> createCouple() async {
    final userId = _supabase.auth.currentUser!.id;

    final existing = await getExistingCode();
    if (existing != null) return existing;

    final code = _generateCode();

    final couple = await _supabase
        .from('couples')
        .insert({'user_a_id': userId, 'invite_code': code})
        .select('id')
        .single();

    await _supabase
        .from('profiles')
        .update({'couple_id': couple['id']})
        .eq('id', userId);

    return code;
  }

  @override
  Future<void> joinCouple(String inviteCode) async {
    final userId = _supabase.auth.currentUser!.id;

    final couple = await _supabase
        .from('couples')
        .select('id, user_b_id')
        .eq('invite_code', inviteCode.toUpperCase())
        .single();

    if (couple['user_b_id'] != null) {
      throw Exception('קוד זה כבר בשימוש');
    }

    await _supabase
        .from('couples')
        .update({'user_b_id': userId})
        .eq('id', couple['id'] as String);

    await _supabase
        .from('profiles')
        .update({'couple_id': couple['id']})
        .eq('id', userId);
  }

  @override
  Future<bool> isLinked() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    final profile = await _supabase
        .from('profiles')
        .select('couple_id')
        .eq('id', userId)
        .maybeSingle();

    return profile?['couple_id'] != null;
  }

  @override
  Future<String?> getExistingCode() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final profile = await _supabase
        .from('profiles')
        .select('couple_id')
        .eq('id', userId)
        .maybeSingle();

    final coupleId = profile?['couple_id'];
    if (coupleId == null) return null;

    final couple = await _supabase
        .from('couples')
        .select('invite_code, user_b_id')
        .eq('id', coupleId as String)
        .maybeSingle();

    if (couple == null || couple['user_b_id'] != null) return null;
    return couple['invite_code'] as String?;
  }

  @override
  Future<bool> isFullyLinked() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    final profile = await _supabase
        .from('profiles')
        .select('couple_id')
        .eq('id', userId)
        .maybeSingle();

    final coupleId = profile?['couple_id'];
    if (coupleId == null) return false;

    final couple = await _supabase
        .from('couples')
        .select('user_b_id')
        .eq('id', coupleId as String)
        .maybeSingle();

    return couple?['user_b_id'] != null;
  }
}
