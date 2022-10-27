import 'package:equatable/equatable.dart';

abstract class LoginEvent {}

class LoginUserNameChanged extends LoginEvent {
  final String username;
  LoginUserNameChanged({required this.username});
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  LoginPasswordChanged({required this.password});
}

class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;
  LoginSubmitted({required this.username, required this.password});
}

class RememberMe extends LoginEvent {}

class ForgetPassword extends LoginEvent {}
