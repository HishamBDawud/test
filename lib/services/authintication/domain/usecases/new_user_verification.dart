import 'package:cleanapp/services/authintication/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

class NewUserVerificationUsercase {
  UserRepo repo;
  NewUserVerificationUsercase({required this.repo});

  Future<Either<Failure, bool>> call(
      String username, String loginToken, String OTP) {
    return repo.newUserVerify(username, loginToken, OTP);
  }
}
