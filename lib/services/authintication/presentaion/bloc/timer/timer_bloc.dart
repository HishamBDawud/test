import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cleanapp/core/constants/api_constants.dart';
import 'package:cleanapp/services/authintication/domain/usecases/delete_storage.dart';
import 'package:cleanapp/services/authintication/domain/usecases/login_user.dart';
import 'package:cleanapp/services/authintication/domain/usecases/read_storage.dart';
import 'package:cleanapp/services/authintication/domain/usecases/write_storage.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/timer/timer_model.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/strings/failure.dart';
import 'timer_event.dart';
import 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  static const _duration = 60;
  final DeleteStorage deleteStorage;
  final LoginUserUseCase loginUser;
  final ReadStorage readStorage;
  final WriteStorage writeStorage;
  StreamSubscription<int>? _tickerSubscription;

  TimerBloc(
      {required Ticker ticker,
      required this.deleteStorage,
      required this.loginUser,
      required this.readStorage,
      required this.writeStorage})
      : _ticker = ticker,
        super(const TimerInitial(_duration)) {
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerReset>(_onReset);
    on<CodeEnded>(_codeEnded);
    on<Finish>(_onFinish);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const TimerRunInProgress(_duration));

    _tickerSubscription = _ticker
        .tick(ticks: _duration)
        .listen((duration) => add(TimerTicked(duration)));
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(event.duration > 0
        ? TimerRunInProgress(event.duration)
        : const TimerRunComplete());
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) async {
    _tickerSubscription?.cancel();
    List<String> myList = [];
    var username = await readStorage.call("UserName");
    var password = await readStorage.call("Password");
    username.fold((failure) {
      var fail = _mapFailureToMessage(failure);
      emit(ResendCodeFaild(message: fail));
    }, (response) {
      myList.add(response);
    });
    password.fold((failure) {
      var fail = _mapFailureToMessage(failure);
      emit(ResendCodeFaild(message: fail));
    }, ((response) {
      myList.add(response);
    }));
    log(myList.toString());
    if (myList.length >= 2) {
      final login = await loginUser.call(myList[0], myList[1], securityKey);
      login.fold((failure) {
        var fail = _mapFailureToMessage(failure);
        emit(ResendCodeFaild(message: fail));
      }, (response) async {
        emit(const ResendCodeSuccess(_duration));
        await writeStorage.call("LoginToken", response["LoginToken"]);
      });
    } else {
      emit(const ResendCodeFaild(message: EMPTY_CACHE_FAILURE_MESSAGE));
    }
  }

  void _codeEnded(CodeEnded event, Emitter<TimerState> emit) async {
    await deleteStorage.call("LoginToken");
  }

  void _onFinish(Finish event, Emitter<TimerState> emit) {
    _tickerSubscription!.cancel();
    emit(const Finishing(60));
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
