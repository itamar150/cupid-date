import 'package:cupid_date/domain/repositories/couple_repository.dart';

class IsCoupleLinkedUseCase {
  const IsCoupleLinkedUseCase(this._repo);
  final CoupleRepository _repo;

  Future<bool> call() => _repo.isLinked();
}
