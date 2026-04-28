import 'package:cupid_date/domain/repositories/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<bool> profileExists(String userId) async {
    final result = await _supabase
        .from('profiles')
        .select('id')
        .eq('id', userId)
        .maybeSingle();
    return result != null;
  }

  @override
  Future<void> createProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String area,
    required int maxRadius,
    required List<String> foodPreferences,
    required bool surpriseOptIn,
  }) async {
    await _supabase.from('profiles').upsert({
      'id': userId,
      'name': firstName,
      'last_name': lastName,
      'email': email,
      'area': area,
      'surprise_opt_in': surpriseOptIn,
    });

    await _supabase.from('preferences').upsert({
      'user_id': userId,
      'max_radius_km': maxRadius,
      'dietary': foodPreferences,
    });
  }
}
