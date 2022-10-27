abstract class NewVerificationState {}

class InitialState implements NewVerificationState {}

class OtpEntered implements NewVerificationState {
  final String otp;
  OtpEntered({required this.otp});
}

class OtpSubmissionFailed implements NewVerificationState {
  final String message;
  OtpSubmissionFailed({required this.message});
}

class OtpTimedout implements NewVerificationState {
  final String message;
  OtpTimedout({required this.message});
}

class OtpSubmissionSuccess implements NewVerificationState {
  final bool flag;
  OtpSubmissionSuccess({required this.flag});
}
