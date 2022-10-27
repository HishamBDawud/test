import 'dart:developer';
import 'dart:convert';
import 'package:cleanapp/core/constants/api_constants.dart';
import 'package:cleanapp/core/error/exception.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

abstract class UserRemoteDataSource {
  Future<Map<String, dynamic>> loginUser(
      String username, String password, String secret);
  Future<Map<String, dynamic>> verifyUser(
      String username, String password, String loginToken, String OTP);
  Future<Map<String, dynamic>> getUserInfo(String userId, String token);
  Future<Map<String, dynamic>> isFirstTime(String username, String secret);
  Future<bool> newUserPassword(
      String username, String password, String GUID, String OTP);
  Future<bool> newUserVerify(String username, String loginToken, String OTP);
}

class UserRemoteImplWithHttp implements UserRemoteDataSource {
  @override
  Future<Map<String, dynamic>> loginUser(
      String username, String password, String secret) async {
    var headers = {
      'UserName': "moh.salfiti@gmail.com",
      'Password': password,
      'SecurityKey': secret
    };
    var url = Uri.https(base, path);
    final response = await http.post(url, headers: headers);
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      decodedResponse["UserName"] = username;
      decodedResponse["Password"] = password;
      log(decodedResponse.toString());
      return Future.value(decodedResponse);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> verifyUser(
      String username, String password, String loginToken, String OTP) async {
    var headers = {
      "UserName": "moh.salfiti@gmail.com",
      "Password": password,
      "LoginToken": loginToken,
      "OTP": OTP
    };
    var url = Uri.https(base, path2);
    final response = await http.post(url, headers: headers);
    log(response.body.toString());
    if (response.statusCode == 200) {
      final value = json.decode(response.body);
      value['UserName'] = username;
      value['Password'] = password;
      log(value.toString());
      return Future.value(value);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getUserInfo(String userId, String token) async {
    var headers = {"userId": userId, 'Authorization': 'Bearer $token'};
    var url = Uri.https(base, path3);
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final value = json.decode(response.body);
      return Future.value(value);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> isFirstTime(
      String username, String secret) async {
    var headers = {"UserName": username, "SecurityKey": secret};
    var url = Uri.https(base, path5);
    final respone = await http.post(url, headers: headers);
    log(respone.body.toString());
    if (respone.statusCode == 200) {
      final value = json.decode(respone.body);
      return Future.value(value);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> newUserPassword(
      String username, String password, String GUID, String OTP) async {
    var headers = {
      "UserName": username,
      "Password": password,
      "GUID": GUID,
      "OTP": OTP
    };
    var url = Uri.https(base, path6);
    final response = await http.post(url, headers: headers);
    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> newUserVerify(
      String username, String loginToken, String OTP) async {
    var headers = {"UserName": username, "GUID": loginToken, "OTP": OTP};
    var url = Uri.https(base, path7);
    final response = await http.post(url, headers: headers);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException();
    }
  }
}
