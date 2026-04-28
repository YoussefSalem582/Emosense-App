import 'package:equatable/equatable.dart';

import 'user_entity.dart';

/// Successful auth call: signed-in user plus opaque token string (demo or JWT).
class AuthResponseEntity extends Equatable {
  const AuthResponseEntity({required this.user, required this.token});

  final UserEntity user;
  final String token;

  @override
  List<Object?> get props => [user, token];
}
