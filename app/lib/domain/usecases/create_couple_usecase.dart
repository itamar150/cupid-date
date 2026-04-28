import 'package:cupid_date/domain/repositories/couple_repository.dart';

class CreateCoupleUseCase {
  const CreateCoupleUseCase(this._repo);
  final CoupleRepository _repo;

  Future<String> call() => _repo.createCouple();
}
