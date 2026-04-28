import 'package:cupid_date/domain/repositories/auth_repository.dart';

class SendOtpUseCase {
  const SendOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call(String email) => _repository.sendOtp(email.trim());
}
