import 'dart:developer';

import 'package:cleanapp/services/authintication/domain/usecases/get_user_details.dart';
import 'package:cleanapp/services/authintication/domain/usecases/read_storage.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/profile/profile_event.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/profile/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/strings/failure.dart';
import '../../../domain/entities/user.dart';

class ProfileBLoc extends Bloc<ProfileEvent, ProfileState> {
  getUserDetailsUseCase userInfo;
  ReadStorage readStorage;
  ProfileBLoc({required this.readStorage, required this.userInfo})
      : super(InitState()) {
    on<ProfileEvent>(((event, emit) async {
      List<String> myList = [];
      var userId = await readStorage.call("userId");
      var token = await readStorage.call("accessToken");
      userId.fold((failure) {
        var fail = _mapFailureToMessage(failure);
        emit(LoadingFaild(message: fail));
      }, (response) {
        myList.add(response);
      });
      token.fold((failure) {
        var fail = _mapFailureToMessage(failure);
        emit(LoadingFaild(message: fail));
      }, (response) {
        myList.add(response);
      });
      if (myList.isNotEmpty) {
        final user = await userInfo.call(myList[0], myList[1]);
        user.fold((failure) {
          var fail = _mapFailureToMessage(failure);
          emit(LoadingFaild(message: fail));
        }, (response) {
          log(response.toString());
          log(response['IdNo'].toString());
          User user = User(
              idNo: response['idNo'].toString(),
              firstName: response['FirstName'].toString(),
              midName: response['MidName'].toString(),
              lastName: response['LastName'].toString(),
              thirdName: response['ThirdName'].toString(),
              nationality: response['Nationality'].toString(),
              address: response['Address'].toString(),
              comment: response['Comment'].toString(),
              profileImage: response['ProfileImage'].toString(),
              status: response['Status'].toString(),
              email: response['Email'].toString(),
              phoneNumber: response['PhoneNumber'].toString());
          emit(Loaded(user: user));
        });
      } else if (event is StopLoading) {
        emit(FinishedLoading());
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
