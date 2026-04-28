abstract interface class CoupleRepository {
  Future<String> createCouple();
  Future<void> joinCouple(String inviteCode);
  Future<bool> isLinked();
  Future<bool> isFullyLinked();
  Future<String?> getExistingCode();
}
