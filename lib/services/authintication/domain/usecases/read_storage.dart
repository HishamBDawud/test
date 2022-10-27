import 'package:cleanapp/core/error/failure.dart';
import 'package:cleanapp/services/authintication/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';

class ReadStorage {
  final UserRepo repo;
  ReadStorage(this.repo);

  Future<Either<Failure, String>> call(String key) async {
    return await repo.readSecureData(key);
  }
}
