abstract interface class ProfileRepository {
  Future<bool> profileExists(String userId);
  Future<void> createProfile({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String area,
    required int maxRadius,
    required List<String> foodPreferences,
    required bool surpriseOptIn,
  });
}
