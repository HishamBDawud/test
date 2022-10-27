abstract class NewPasswordState {}

class InitialState implements NewPasswordState {}

class PasswordChanged implements NewPasswordState {
  final String password;
  PasswordChanged({required this.password});
}

class SubmissionFailed implements NewPasswordState {
  final String message;
  SubmissionFailed({required this.message});
}

class SubmissionSuccess implements NewPasswordState {
  final String message;
  SubmissionSuccess({required this.message});
}
