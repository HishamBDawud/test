abstract class PasswordEvent {}

class GetUsername extends PasswordEvent {
  String password;
  String username;
  GetUsername({required this.username, required this.password});
}

class Submitted extends PasswordEvent {
  String username;
  String password;
  Submitted({required this.password, required this.username});
}
