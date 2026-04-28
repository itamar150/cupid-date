import 'package:cupid_date/domain/repositories/auth_repository.dart';
import 'package:cupid_date/domain/repositories/profile_repository.dart';

class CreateProfileUseCase {
  const CreateProfileUseCase(this._profileRepo, this._authRepo);

  final ProfileRepository _profileRepo;
  final AuthRepository _authRepo;

  Future<void> call({
    required String firstName,
    required String lastName,
    required String email,
    required String area,
    required int maxRadius,
    required List<String> foodPreferences,
    required bool surpriseOptIn,
  }) {
    final userId = _authRepo.currentUserId;
    if (userId == null) throw StateError('no authenticated user');
    return _profileRepo.createProfile(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      area: area,
      maxRadius: maxRadius,
      foodPreferences: foodPreferences,
      surpriseOptIn: surpriseOptIn,
    );
  }
}
