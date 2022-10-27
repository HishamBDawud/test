import 'package:cleanapp/services/authintication/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

class getUserDetailsUseCase {
  final UserRepo repo;

  getUserDetailsUseCase({required this.repo});

  Future<Either<Failure, Map<String, dynamic>>> call(
      String userId, String token) async {
    return await repo.getUserDetails(userId, token);
  }
}
