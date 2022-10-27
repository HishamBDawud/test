import 'package:cleanapp/services/authintication/domain/usecases/new_user_verification.dart';
import 'package:cleanapp/services/authintication/domain/usecases/read_storage.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/newUserVerification/new_verificaiton_state.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/newUserVerification/new_verification_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/strings/failure.dart';

class NewVerificationBloc
    extends Bloc<NewVerificationEvent, NewVerificationState> {
  NewUserVerificationUsercase newVerify;
  ReadStorage readStorage;
  NewVerificationBloc({required this.newVerify, required this.readStorage})
      : super(InitialState()) {
    on<NewVerificationEvent>(
      (event, emit) async {
        if (event is OtpChanged) {
          emit(OtpEntered(otp: event.otp));
        } else if (event is OtpSubmitted) {
          var loginToken = await readStorage.call("LoginToken");
          loginToken.fold((failure) async {
            var fail = _mapFailureToMessage(failure);
            emit(OtpSubmissionFailed(message: fail));
          }, (response) async {
            var isValid =
                await newVerify.call(event.username, response, event.otp);
            isValid.fold((failure) {
              var fail = _mapFailureToMessage(failure);
              emit(OtpSubmissionFailed(message: fail));
            }, (response) {
              emit(OtpSubmissionSuccess(flag: response));
            });
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
