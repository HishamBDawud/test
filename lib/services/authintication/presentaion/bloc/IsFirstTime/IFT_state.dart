abstract class IFTState {}

class InitialState implements IFTState {}

class UserNameEntered implements IFTState {
  String username;
  UserNameEntered({required this.username});
}

class Submitting implements IFTState {}

class SubmissionFailed implements IFTState {
  String message;
  SubmissionFailed({required this.message});
}

class SubmissionSuccess implements IFTState {
  bool flag;
  SubmissionSuccess({required this.flag});
}
