import 'package:cleanapp/services/authintication/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

class NewUserPasswordUsecase {
  final UserRepo repo;
  NewUserPasswordUsecase({required this.repo});

  Future<Either<Failure, bool>> call(
      String username, String newPassword, String GUID, String OTP) {
    return repo.newUserPassword(username, newPassword, GUID, OTP);
  }
}
