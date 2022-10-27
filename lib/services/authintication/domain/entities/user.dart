import 'package:cleanapp/core/constants/api_constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class User extends Equatable {
  final String idNo;
  final String firstName;
  final String midName;
  final String thirdName;
  final String lastName;
  final String nationality;
  final String address;
  final String comment;
  final String profileImage;
  final String status;
  final String email;
  final String phoneNumber;
  const User(
      {required this.idNo,
      required this.firstName,
      required this.midName,
      required this.thirdName,
      required this.lastName,
      required this.nationality,
      required this.address,
      required this.comment,
      required this.status,
      required this.email,
      required this.phoneNumber,
      required this.profileImage});

  @override
  List<Object?> get props => [
        idNo,
        firstName,
        midName,
        lastName,
        thirdName,
        nationality,
        address,
        comment,
        status,
        email,
        phoneNumber
      ];
}
