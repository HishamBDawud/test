import 'dart:developer';

import 'package:cleanapp/services/authintication/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

class LoginUserUseCase {
  final UserRepo repo;
  LoginUserUseCase({required this.repo});

  Future<Either<Failure, Map<String, dynamic>>> call(
      String username, String password, String secret) async {
    return await repo.loginUser(username, password, secret);
  }
}
