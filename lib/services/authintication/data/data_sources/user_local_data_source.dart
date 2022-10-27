import 'package:cleanapp/core/error/exception.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class UserLocalDataSource {
  Future<String> readSecuredData(String value);
  Future<Unit> writeSecuredData(String key, String value);
  Future<Unit> deleteSecuredData(String key);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  UserLocalDataSourceImpl({required this.secureStorage});
  final FlutterSecureStorage secureStorage;
  @override
  Future<String> readSecuredData(String key) async {
    var readData = await secureStorage.read(key: key);
    if (readData != null) {
      return Future.value(readData);
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<Unit> writeSecuredData(String key, String value) async {
    await secureStorage.write(key: key, value: value);
    return Future.value(unit);
  }

  @override
  Future<Unit> deleteSecuredData(String key) async {
    await secureStorage.delete(key: key);
    return Future.value(unit);
  }
}
