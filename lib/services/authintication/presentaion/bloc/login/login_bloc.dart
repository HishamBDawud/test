// ignore_for_file: void_checks

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cleanapp/core/constants/api_constants.dart';
import 'package:cleanapp/core/error/failure.dart';
import 'package:cleanapp/core/strings/failure.dart';
import 'package:cleanapp/services/authintication/domain/usecases/login_user.dart';
import 'package:cleanapp/services/authintication/domain/usecases/write_storage.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/verification/verify_state.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUserUseCase loginUser;
  final WriteStorage writeUserData;
  LoginBloc({required this.loginUser, required this.writeUserData})
      : super(InitialStatus()) {
    on<LoginEvent>((event, emit) async {
      if (event is LoginUserNameChanged) {
        emit(UserNameEntered(username: event.username));
        log(event.username);
      } else if (event is LoginPasswordChanged) {
        emit(PasswordEntered(password: event.password));
      } else if (event is LoginSubmitted) {
        emit(Submitting(username: event.username, password: event.password));
        final login =
            await loginUser.call(event.username, event.password, securityKey);
        login.fold((failure) async {
          emit(SubmissionFailed(message: _mapFailureToMessage(failure)));
        }, (response) async {
          emit(SubmissionSuccess(message: response['LoginToken']));
          await writeUserData.call("UserName", response['UserName']);
          await writeUserData.call("Password", response['Password']);
          await writeUserData.call("LoginToken", response['LoginToken']);
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
