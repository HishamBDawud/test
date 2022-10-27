import 'dart:developer';

import 'package:cleanapp/core/constants/api_constants.dart';
import 'package:cleanapp/services/authintication/domain/usecases/is_first_time.dart';
import 'package:cleanapp/services/authintication/domain/usecases/write_storage.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/IsFirstTime/IFT_event.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/IsFirstTime/IFT_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/strings/failure.dart';

class IFTBloc extends Bloc<IFTEvent, IFTState> {
  final IsFirstTime isFirstTime;
  final WriteStorage writeStorage;
  IFTBloc({required this.isFirstTime, required this.writeStorage})
      : super(InitialState()) {
    on<IFTEvent>((event, emit) async {
      if (event is UserNameChanged) {
        emit(UserNameEntered(username: event.username));
      } else if (event is Sumbitted) {
        bool flag;
        String username = event.username;
        final isFirst = await isFirstTime.call(event.username, securityKey);
        isFirst.fold((failure) {
          var fail = _mapFailureToMessage(failure);
          emit(SubmissionFailed(message: fail));
        }, (response) async {
          emit(SubmissionSuccess(flag: response['IsFirstTimeLogin']));
          flag = response['IsFirstTimeLogin'];
          if (flag == true) {
            var token =
                await writeStorage.call("LoginToken", response['LoginToken']);
            var myUsername = await writeStorage.call("UserName", username);
            token.fold((failure) async {
              var fail = _mapFailureToMessage(failure);
              emit(SubmissionFailed(message: fail));
            }, (response) async {});
            myUsername.fold((failure) {
              var fail = _mapFailureToMessage(failure);
              emit(SubmissionFailed(message: fail));
            }, (response) {});
          } else {
            var myUsername =
                await writeStorage.call("UserName", event.username);
            myUsername.fold((failure) {
              var fail = _mapFailureToMessage(failure);
              emit(SubmissionFailed(message: fail));
            }, (response) async {});
          }
        });
      }
    });
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
