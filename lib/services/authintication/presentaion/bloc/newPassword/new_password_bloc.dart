import 'package:cleanapp/services/authintication/domain/usecases/new_user_password.dart';
import 'package:cleanapp/services/authintication/domain/usecases/read_storage.dart';
import 'package:cleanapp/services/authintication/domain/usecases/write_storage.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/newPassword/new_password_event.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/newPassword/new_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/strings/failure.dart';

class NewPasswordBloc extends Bloc<NewPasswordEvent, NewPasswordState> {
  NewUserPasswordUsecase newUserPassword;
  WriteStorage writeStorage;
  ReadStorage readStorage;
  NewPasswordBloc(
      {required this.newUserPassword,
      required this.readStorage,
      required this.writeStorage})
      : super(InitialState()) {
    on<NewPasswordEvent>(
      (event, emit) async {
        if (event is PasswordEnterd) {
          emit(PasswordChanged(password: event.password));
        } else if (event is ButtonSubmitted) {
          Map<String, String> myMap = {};
          var username = await readStorage.call("UserName");
          var GUID = await readStorage.call("LoginToken");
          username.fold((failure) {
            var fail = _mapFailureToMessage(failure);
            emit(SubmissionFailed(message: fail));
          }, (response) {
            myMap['UserName'] = response;
          });
          GUID.fold((failure) {
            var fail = _mapFailureToMessage(failure);
            emit(SubmissionFailed(message: fail));
          }, (response) {
            myMap['GUID'] = response;
          });

          var newPassword = await newUserPassword.call(
              myMap['UserName']!, event.password, myMap['GUID']!, event.OTP);
          newPassword.fold((failure) {
            var fail = _mapFailureToMessage(failure);
            emit(SubmissionFailed(message: fail));
          }, (response) {
            emit(SubmissionSuccess(message: "Successs"));
          });
        }
      },
    );
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
