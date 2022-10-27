import 'dart:developer';

import 'package:cleanapp/core/constants/api_constants.dart';
import 'package:cleanapp/services/authintication/domain/usecases/login_user.dart';
import 'package:cleanapp/services/authintication/domain/usecases/read_storage.dart';
import 'package:cleanapp/services/authintication/domain/usecases/verify_user.dart';
import 'package:cleanapp/services/authintication/domain/usecases/write_storage.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/verification/verify_event.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/verification/verify_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/retry.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/strings/failure.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  final VerifyUserUseCase verifyUser;
  final ReadStorage readUserData;
  final WriteStorage writeUserData;
  VerifyBloc({
    required this.verifyUser,
    required this.readUserData,
    required this.writeUserData,
  }) : super(InitialState()) {
    on<VerifyEvent>(((event, emit) async {
      if (event is OtpChanged) {
        emit(OtpEntered(otp: event.otp));
      } else if (event is OtpSubmitted) {
        log(event.otp);
        List<String> myList = [];
        var username = await readUserData.call("UserName");
        var password = await readUserData.call("Password");
        var loginToken = await readUserData.call("LoginToken");
        username.fold((failure) {
          var fail = _mapFailureToMessage(failure);
          emit(OtpSubmissionFailed(message: fail));
        }, (response) {
          myList.add(response);
        });
        password.fold((failure) {
          var fail = _mapFailureToMessage(failure);
          emit(OtpSubmissionFailed(message: fail));
        }, (response) {
          myList.add(response);
        });
        loginToken.fold((failure) {
          var fail = _mapFailureToMessage(failure);
          emit(OtpSubmissionFailed(message: fail));
        }, (response) {
          myList.add(response);
        });
        if (myList.length >= 3) {
          final verify =
              await verifyUser.call(myList[0], myList[1], myList[2], event.otp);
          verify.fold((failure) {
            emit(OtpSubmissionFailed(message: _mapFailureToMessage(failure)));
          }, (response) async {
            emit(OtpSubmissionSuccess());
            await writeUserData.call("accessToken", response['accessToken']);
            await writeUserData.call("userId", response['userId']);
          });
        } else {
          emit(OtpSubmissionFailed(message: EMPTY_CACHE_FAILURE_MESSAGE));
        }
      }
    }));
  }
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
