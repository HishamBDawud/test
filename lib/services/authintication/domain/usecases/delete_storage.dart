import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/user_repo.dart';

class DeleteStorage {
  final UserRepo repo;
  DeleteStorage({required this.repo});

  Future<Either<Failure, Unit>> call(String key) async {
    return await repo.deleteSecureData(key);
  }
}
