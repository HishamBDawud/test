abstract class ProfileEvent {
  ProfileEvent();
}

class LoadProfileInfo extends ProfileEvent {}

class StopLoading extends ProfileEvent {}
