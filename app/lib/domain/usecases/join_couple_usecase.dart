import 'package:cupid_date/domain/repositories/couple_repository.dart';

class JoinCoupleUseCase {
  const JoinCoupleUseCase(this._repo);
  final CoupleRepository _repo;

  Future<void> call(String inviteCode) => _repo.joinCouple(inviteCode);
}
