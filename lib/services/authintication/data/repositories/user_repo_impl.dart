import 'dart:developer';

import 'package:cleanapp/core/error/exception.dart';
import 'package:cleanapp/core/network/network_info.dart';
import 'package:cleanapp/core/error/failure.dart';
import 'package:cleanapp/services/authintication/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';

import '../data_sources/user_local_data_source.dart';
import '../data_sources/user_remote_data_source.dart';

class UserRepoImplement implements UserRepo {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepoImplement(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});
  @override
  Future<Either<Failure, Map<String, dynamic>>> loginUser(
      String username, String password, String secret) async {
    if (await networkInfo.isConnectd) {
      try {
        final remoteResponse =
            await remoteDataSource.loginUser(username, password, secret);
        return Right(remoteResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, String>> readSecureData(String key) async {
    try {
      final value = await localDataSource.readSecuredData(key);
      return Right(value);
    } catch (e) {
      return Left(EmptyCacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> writeSecureData(
      String key, String value) async {
    try {
      await localDataSource.writeSecuredData(key, value);
      return const Right(unit);
    } catch (e) {
      return Left(EmptyCacheFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyUser(
      String username, String password, String loginToken, String OTP) async {
    if (await networkInfo.isConnectd) {
      try {
        final remoteResponse = await remoteDataSource.verifyUser(
            username, password, loginToken, OTP);
        return Right(remoteResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSecureData(String key) async {
    try {
      await localDataSource.deleteSecuredData(key);
      return Future.value(const Right(unit));
    } catch (e) {
      return Left(EmptyCacheFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUserDetails(
      String userId, String token) async {
    if (await networkInfo.isConnectd) {
      try {
        final remoteResponse =
            await remoteDataSource.getUserInfo(userId, token);
        return Right(remoteResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> isFirstTime(
      String username, String secret) async {
    if (await networkInfo.isConnectd) {
      try {
        final remoteResponse =
            await remoteDataSource.isFirstTime(username, secret);
        return Right(remoteResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> newUserPassword(
      String username, String password, String GUID, String OTP) async {
    if (await networkInfo.isConnectd) {
      try {
        final remoteResponse = await remoteDataSource.newUserPassword(
            username, password, GUID, OTP);
        return Right(remoteResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> newUserVerify(
      String username, String loginToken, String OTP) async {
    if (await networkInfo.isConnectd) {
      try {
        final remoteResponse =
            await remoteDataSource.newUserVerify(username, loginToken, OTP);
        return Right(remoteResponse);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
