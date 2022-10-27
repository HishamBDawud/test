abstract class IFTEvent {}

class UserNameChanged extends IFTEvent {
  String username;
  UserNameChanged({required this.username});
}

class Sumbitted extends IFTEvent {
  String username;
  Sumbitted({required this.username});
}
