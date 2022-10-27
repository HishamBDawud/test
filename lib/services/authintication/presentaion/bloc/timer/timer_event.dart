import 'package:equatable/equatable.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent {
  final int duration;
  const TimerStarted(this.duration);
}

class TimerPaused extends TimerEvent {
  const TimerPaused();
}

class TimerResumed extends TimerEvent {
  final int duration;
  const TimerResumed(this.duration);
}

class TimerReset extends TimerEvent {}

class TimerTicked extends TimerEvent {
  final int duration;
  const TimerTicked(this.duration);

  @override
  List<Object> get props => [duration];
}

class CodeEnded extends TimerEvent {}

class Finish extends TimerEvent {}
