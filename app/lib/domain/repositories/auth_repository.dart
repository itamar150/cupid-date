abstract interface class AuthRepository {
  Stream<bool> get isAuthenticated;
  Future<void> sendOtp(String email);
  Future<void> verifyOtp({required String email, required String token});
  Future<void> signInWithGoogle();
  Future<void> signOut();
  String? get currentUserId;
}
