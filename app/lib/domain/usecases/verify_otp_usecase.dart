import 'package:cupid_date/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String email, required String token}) =>
      _repository.verifyOtp(email: email, token: token);
}
