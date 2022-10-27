import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class UserRepo {
  Future<Either<Failure, Map<String, dynamic>>> loginUser(
      String username, String password, String secret);
  Future<Either<Failure, Unit>> writeSecureData(String key, String value);
  Future<Either<Failure, String>> readSecureData(String key);
  Future<Either<Failure, Map<String, dynamic>>> verifyUser(
      String username, String password, String loginToken, String OTP);
  Future<Either<Failure, Unit>> deleteSecureData(String key);
  Future<Either<Failure, Map<String, dynamic>>> getUserDetails(
      String userId, String token);
  Future<Either<Failure, Map<String, dynamic>>> isFirstTime(
      String username, String secret);
  Future<Either<Failure, bool>> newUserPassword(
      String username, String password, String GUID, String OTP);
  Future<Either<Failure, bool>> newUserVerify(
      String username, String loginToken, String OTP);
}
