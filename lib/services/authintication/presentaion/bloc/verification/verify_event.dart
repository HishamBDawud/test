abstract class VerifyEvent {
  const VerifyEvent();
}

class OtpChanged extends VerifyEvent {
  final String otp;
  OtpChanged({required this.otp});
}

class OtpSubmitted extends VerifyEvent {
  final String otp;
  OtpSubmitted({required this.otp});
}

class OtpResendCode extends VerifyEvent {}
