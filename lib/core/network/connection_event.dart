part of 'connection_bloc.dart';

abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object?> get props => [];
}

class ConnectionInitializeRequested extends ConnectionEvent {
  const ConnectionInitializeRequested();
}

class ConnectionEnvironmentConnectRequested extends ConnectionEvent {
  const ConnectionEnvironmentConnectRequested();
}

class ConnectionBackendConnectRequested extends ConnectionEvent {
  final BackendConfig config;

  const ConnectionBackendConnectRequested(this.config);

  @override
  List<Object?> get props => [config];
}

class ConnectionTestRequested extends ConnectionEvent {
  const ConnectionTestRequested();
}

class ConnectionRetryRequested extends ConnectionEvent {
  const ConnectionRetryRequested();
}

class ConnectionDisconnectRequested extends ConnectionEvent {
  const ConnectionDisconnectRequested();
}

class ConnectionSwitchRequested extends ConnectionEvent {
  final BackendConfig config;

  const ConnectionSwitchRequested(this.config);

  @override
  List<Object?> get props => [config];
}

/// Dispatched from [ConnectionManager.statusStream] (must use [add], not [emit]).
class ConnectionManagerStatusChanged extends ConnectionEvent {
  final ConnectionStatus status;

  const ConnectionManagerStatusChanged(this.status);

  @override
  List<Object?> get props => [status];
}
