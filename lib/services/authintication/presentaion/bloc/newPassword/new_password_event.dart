abstract class NewPasswordEvent {}

class PasswordEnterd extends NewPasswordEvent {
  final String password;
  PasswordEnterd({required this.password});
}

class ButtonSubmitted extends NewPasswordEvent {
  final String OTP;
  final String password;
  final String username;
  ButtonSubmitted(
      {required this.password, required this.OTP, required this.username});
}
