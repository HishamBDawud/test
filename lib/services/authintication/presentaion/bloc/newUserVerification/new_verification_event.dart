abstract class NewVerificationEvent {
  const NewVerificationEvent();
}

class OtpChanged extends NewVerificationEvent {
  final String otp;
  OtpChanged({required this.otp});
}

class OtpSubmitted extends NewVerificationEvent {
  final String username;
  final String otp;
  OtpSubmitted({required this.otp, required this.username});
}

class OtpResendCode extends NewVerificationEvent {}
