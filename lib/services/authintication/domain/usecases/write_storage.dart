import 'package:cleanapp/core/error/failure.dart';
import 'package:cleanapp/services/authintication/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';

class WriteStorage {
  final UserRepo repo;

  WriteStorage(this.repo);
  Future<Either<Failure, Unit>> call(String key, String value) async {
    return await repo.writeSecureData(key, value);
  }
}
