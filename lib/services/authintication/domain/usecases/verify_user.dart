import 'package:cleanapp/services/authintication/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

class VerifyUserUseCase {
  final UserRepo repo;
  VerifyUserUseCase({required this.repo});

  Future<Either<Failure, Map<String, dynamic>>> call(
      String username, String password, String loginToken, String OTP) async {
    return await repo.verifyUser(username, password, loginToken, OTP);
  }
}
