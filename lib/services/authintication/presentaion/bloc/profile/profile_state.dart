import '../../../domain/entities/user.dart';

abstract class ProfileState {}

class InitState implements ProfileState {}

class IsLoading implements ProfileState {}

class Loaded implements ProfileState {
  final User user;
  Loaded({required this.user});
}

class LoadingFaild implements ProfileState {
  final String message;
  LoadingFaild({required this.message});
}

class FinishedLoading implements ProfileState {}
