abstract class LoginState {}

class InitialStatus implements LoginState {}

class UserNameEntered implements LoginState {
  final String username;
  UserNameEntered({required this.username});
}

class PasswordEntered implements LoginState {
  final String password;
  PasswordEntered({required this.password});
}

class Submitting extends LoginState {
  final String username;
  final String password;

  Submitting({required this.username, required this.password});
}

class SubmissionSuccess extends LoginState {
  final String message;

  SubmissionSuccess({required this.message});
}

class SubmissionFailed extends LoginState {
  final String message;
  SubmissionFailed({required this.message});
}
