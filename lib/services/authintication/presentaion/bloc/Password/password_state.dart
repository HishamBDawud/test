abstract class PasswordState {}

class InitialState implements PasswordState {}

class PasswordEntered implements PasswordState {
  String password;
  String username;
  PasswordEntered({required this.password, required this.username});
}

class SubmittingUser implements PasswordState {
  String username;
  SubmittingUser({required this.username});
}

class SubmissionFailed implements PasswordState {
  String message;
  SubmissionFailed({required this.message});
}

class SubmissionSuccess implements PasswordState {
  String message;
  SubmissionSuccess({required this.message});
}
