import 'package:cupid_date/data/repositories/auth_repository_impl.dart';
import 'package:cupid_date/data/repositories/couple_repository_impl.dart';
import 'package:cupid_date/data/repositories/profile_repository_impl.dart';
import 'package:cupid_date/domain/repositories/auth_repository.dart';
import 'package:cupid_date/domain/repositories/couple_repository.dart';
import 'package:cupid_date/domain/repositories/profile_repository.dart';
import 'package:cupid_date/domain/usecases/create_couple_usecase.dart';
import 'package:cupid_date/domain/usecases/create_profile_usecase.dart';
import 'package:cupid_date/domain/usecases/is_couple_linked_usecase.dart';
import 'package:cupid_date/domain/usecases/join_couple_usecase.dart';
import 'package:cupid_date/domain/usecases/send_otp_usecase.dart';
import 'package:cupid_date/domain/usecases/sign_out_usecase.dart';
import 'package:cupid_date/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabaseClientProvider = Provider<SupabaseClient>(
  (_) => Supabase.instance.client,
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(_supabaseClientProvider)),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(ref.watch(_supabaseClientProvider)),
);

final sendOtpProvider = Provider<SendOtpUseCase>(
  (ref) => SendOtpUseCase(ref.watch(authRepositoryProvider)),
);

final verifyOtpProvider = Provider<VerifyOtpUseCase>(
  (ref) => VerifyOtpUseCase(ref.watch(authRepositoryProvider)),
);

final createProfileProvider = Provider<CreateProfileUseCase>(
  (ref) => CreateProfileUseCase(
    ref.watch(profileRepositoryProvider),
    ref.watch(authRepositoryProvider),
  ),
);

final signOutProvider = Provider<SignOutUseCase>(
  (ref) => SignOutUseCase(ref.watch(authRepositoryProvider)),
);

final signInWithGoogleProvider = Provider<Future<void> Function()>(
  (ref) => () => ref.read(authRepositoryProvider).signInWithGoogle(),
);

final isAuthenticatedProvider = StreamProvider<bool>(
  (ref) => ref.watch(authRepositoryProvider).isAuthenticated,
);

final currentUserNameProvider = FutureProvider<String>((ref) async {
  final userId = ref.watch(authRepositoryProvider).currentUserId;
  if (userId == null) return '';
  final result = await ref
      .watch(_supabaseClientProvider)
      .from('profiles')
      .select('name')
      .eq('id', userId)
      .maybeSingle();
  return (result?['name'] as String?) ?? '';
});

final profileExistsProvider = FutureProvider<bool>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final userId = authRepo.currentUserId;
  if (userId == null) return false;
  return ref.watch(profileRepositoryProvider).profileExists(userId);
});

final coupleRepositoryProvider = Provider<CoupleRepository>(
  (ref) => CoupleRepositoryImpl(ref.watch(_supabaseClientProvider)),
);

final createCoupleProvider = Provider<CreateCoupleUseCase>(
  (ref) => CreateCoupleUseCase(ref.watch(coupleRepositoryProvider)),
);

final joinCoupleProvider = Provider<JoinCoupleUseCase>(
  (ref) => JoinCoupleUseCase(ref.watch(coupleRepositoryProvider)),
);

final vibeProfileCompleteProvider = FutureProvider<bool>((ref) async {
  final userId = ref.watch(authRepositoryProvider).currentUserId;
  if (userId == null) return false;
  final result = await ref
      .watch(_supabaseClientProvider)
      .from('preferences')
      .select('vibe_profile')
      .eq('user_id', userId)
      .maybeSingle();
  final vibes = result?['vibe_profile'] as List?;
  return vibes != null && vibes.isNotEmpty;
});

final isCoupleLinkedProvider = FutureProvider<bool>(
  (ref) => IsCoupleLinkedUseCase(ref.watch(coupleRepositoryProvider)).call(),
);

final isFullyLinkedProvider = FutureProvider<bool>(
  (ref) => ref.watch(coupleRepositoryProvider).isFullyLinked(),
);

final existingInviteCodeProvider = FutureProvider<String?>(
  (ref) => ref.watch(coupleRepositoryProvider).getExistingCode(),
);
