import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/user_entity.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserInitial()) {
    on<UserSet>(_onSet);
    on<UserClear>(_onClear);
    on<UserLoadingStarted>(_onLoading);
    on<UserFailure>(_onFailure);
    on<UserFailureCleared>(_onFailureCleared);
    on<UserPreferencesUpdated>(_onPreferencesUpdated);
  }

  void _onSet(UserSet event, Emitter<UserState> emit) {
    emit(UserAuthenticated(event.user));
  }

  void _onClear(UserClear event, Emitter<UserState> emit) {
    emit(const UserLoggedOut());
  }

  void _onLoading(UserLoadingStarted event, Emitter<UserState> emit) {
    emit(const UserLoading());
  }

  void _onFailure(UserFailure event, Emitter<UserState> emit) {
    emit(UserError(event.message));
  }

  void _onFailureCleared(UserFailureCleared event, Emitter<UserState> emit) {
    if (state is UserError) {
      emit(const UserInitial());
    }
  }

  void _onPreferencesUpdated(
    UserPreferencesUpdated event,
    Emitter<UserState> emit,
  ) {
    if (state is UserAuthenticated) {
      final current = state as UserAuthenticated;
      final u = current.user;
      emit(
        UserAuthenticated(
          UserEntity(
            id: u.id,
            name: u.name,
            email: u.email,
            role: u.role,
            avatar: u.avatar,
            createdAt: u.createdAt,
            preferences: event.preferences,
          ),
        ),
      );
    }
  }
}
