import 'dart:developer';

import 'package:cleanapp/core/constants/api_constants.dart';
import 'package:cleanapp/services/authintication/domain/usecases/login_user.dart';
import 'package:cleanapp/services/authintication/domain/usecases/read_storage.dart';
import 'package:cleanapp/services/authintication/domain/usecases/write_storage.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/Password/password_event.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/Password/password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/strings/failure.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final ReadStorage readStorage;
  final WriteStorage writeStorage;
  final LoginUserUseCase loginUser;
  PasswordBloc(
      {required this.readStorage,
      required this.writeStorage,
      required this.loginUser})
      : super(InitialState()) {
    on<PasswordEvent>(((event, emit) async {
      if (event is Submitted) {
        log(event.username);
        var loginCall =
            await loginUser.call(event.username, event.password, securityKey);
        loginCall.fold((failure) {
          var fail = _mapFailureToMessage(failure);
          emit(SubmissionFailed(message: fail));
        }, (response) async {
          emit(SubmissionSuccess(message: "success"));
          await writeStorage.call("UserName", event.username);
          await writeStorage.call("Password", event.password);
          await writeStorage.call("LoginToken", response['LoginToken']);
        });
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
