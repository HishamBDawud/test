import 'package:cleanapp/services/authintication/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

class IsFirstTime {
  final UserRepo repo;
  IsFirstTime({required this.repo});

  Future<Either<Failure, Map<String, dynamic>>> call(
      String username, String secret) async {
    return await repo.isFirstTime(username, secret);
  }
}
