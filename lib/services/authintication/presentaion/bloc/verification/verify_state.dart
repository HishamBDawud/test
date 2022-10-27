abstract class VerifyState {}

class InitialState implements VerifyState {}

class OtpEntered implements VerifyState {
  final String otp;
  OtpEntered({required this.otp});
}

class OtpSubmissionFailed implements VerifyState {
  final String message;
  OtpSubmissionFailed({required this.message});
}

class OtpTimedout implements VerifyState {
  final String message;
  OtpTimedout({required this.message});
}

class OtpSubmissionSuccess implements VerifyState {}
