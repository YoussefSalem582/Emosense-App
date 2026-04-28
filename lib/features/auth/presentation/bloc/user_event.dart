part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UserSet extends UserEvent {
  final UserEntity user;

  const UserSet(this.user);

  @override
  List<Object?> get props => [user];
}

class UserClear extends UserEvent {
  const UserClear();
}

class UserLoadingStarted extends UserEvent {
  const UserLoadingStarted();
}

class UserFailure extends UserEvent {
  final String message;

  const UserFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UserFailureCleared extends UserEvent {
  const UserFailureCleared();
}

class UserPreferencesUpdated extends UserEvent {
  final UserPreferences preferences;

  const UserPreferencesUpdated(this.preferences);

  @override
  List<Object?> get props => [preferences];
}
