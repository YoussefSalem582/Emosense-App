part of 'connection_bloc.dart';

abstract class BackendConnectionState extends Equatable {
  const BackendConnectionState();

  @override
  List<Object?> get props => [];
}

class ConnectionInitial extends BackendConnectionState {
  const ConnectionInitial();
}

class ConnectionConnecting extends BackendConnectionState {
  const ConnectionConnecting();
}

class ConnectionConnected extends BackendConnectionState {
  final BackendConfig config;
  final Map<String, dynamic>? details;

  const ConnectionConnected({required this.config, this.details});

  @override
  List<Object?> get props => [config, details];
}

class ConnectionDisconnected extends BackendConnectionState {
  const ConnectionDisconnected();
}

class ConnectionError extends BackendConnectionState {
  final String message;
  final Exception? exception;

  const ConnectionError({required this.message, this.exception});

  @override
  List<Object?> get props => [message, exception];
}
