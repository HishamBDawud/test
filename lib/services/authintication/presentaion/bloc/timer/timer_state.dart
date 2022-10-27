import 'package:equatable/equatable.dart';

abstract class TimerState extends Equatable {
  final int duration;
  const TimerState(this.duration);
  @override
  List<Object> get props => [duration];
}

class TimerInitial extends TimerState {
  const TimerInitial(duration) : super(duration);
}

class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(int duration) : super(duration);
}

class TimerRunPause extends TimerState {
  const TimerRunPause(int duration) : super(duration);
}

class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(0);
}

class ResendCodeFaild extends TimerState {
  final String message;
  const ResendCodeFaild({required this.message}) : super(0);
}

class ResendCodeSuccess extends TimerState {
  const ResendCodeSuccess(duration) : super(duration);
}

class Finishing extends TimerState {
  const Finishing(duration) : super(duration);
}
