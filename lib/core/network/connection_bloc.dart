import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'connection_manager.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, BackendConnectionState> {
  final ConnectionManager _connectionManager = ConnectionManager.instance;
  StreamSubscription<ConnectionStatus>? _statusSubscription;
  BackendConfig? _lastConfig;

  ConnectionBloc() : super(const ConnectionInitial()) {
    on<ConnectionInitializeRequested>(_onInitialize);
    on<ConnectionManagerStatusChanged>(_onManagerStatus);
    on<ConnectionEnvironmentConnectRequested>(_onConnectEnvironmentEvent);
    on<ConnectionBackendConnectRequested>(_onConnectBackend);
    on<ConnectionTestRequested>(_onTest);
    on<ConnectionRetryRequested>(_onRetry);
    on<ConnectionDisconnectRequested>(_onDisconnect);
    on<ConnectionSwitchRequested>(_onSwitch);
  }

  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    return super.close();
  }

  Future<void> _onInitialize(
    ConnectionInitializeRequested event,
    Emitter<BackendConnectionState> emit,
  ) async {
    try {
      await _statusSubscription?.cancel();
      _statusSubscription = null;

      await _connectionManager.initialize();

      _statusSubscription = _connectionManager.statusStream.listen((status) {
        add(ConnectionManagerStatusChanged(status));
      });

      await _connectEnvironment(emit);
    } catch (e) {
      emit(
        ConnectionError(
          message: 'Failed to initialize connection: ${e.toString()}',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  void _onManagerStatus(
    ConnectionManagerStatusChanged event,
    Emitter<BackendConnectionState> emit,
  ) {
    switch (event.status) {
      case ConnectionStatus.connecting:
        emit(const ConnectionConnecting());
        break;
      case ConnectionStatus.connected:
        if (_connectionManager.currentConfig != null) {
          emit(
            ConnectionConnected(
              config: _connectionManager.currentConfig!,
              details: _connectionManager.getConnectionDetails(),
            ),
          );
        }
        break;
      case ConnectionStatus.disconnected:
        emit(const ConnectionDisconnected());
        break;
      case ConnectionStatus.error:
        emit(const ConnectionError(message: 'Connection error occurred'));
        break;
    }
  }

  Future<void> _onConnectEnvironmentEvent(
    ConnectionEnvironmentConnectRequested event,
    Emitter<BackendConnectionState> emit,
  ) async {
    await _connectEnvironment(emit);
  }

  Future<void> _connectEnvironment(Emitter<BackendConnectionState> emit) async {
    emit(const ConnectionConnecting());

    try {
      final result = await _connectionManager.connectUsingEnvironment();

      if (!result.success) {
        emit(ConnectionError(message: result.message, exception: result.error));
      }
    } catch (e) {
      emit(
        ConnectionError(
          message: 'Failed to connect: ${e.toString()}',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  Future<void> _onConnectBackend(
    ConnectionBackendConnectRequested event,
    Emitter<BackendConnectionState> emit,
  ) async {
    emit(const ConnectionConnecting());
    _lastConfig = event.config;

    try {
      final result = await _connectionManager.connectToBackend(event.config);

      if (!result.success) {
        emit(ConnectionError(message: result.message, exception: result.error));
      }
    } catch (e) {
      emit(
        ConnectionError(
          message: 'Failed to connect to ${event.config.name}: ${e.toString()}',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  Future<void> _onTest(
    ConnectionTestRequested event,
    Emitter<BackendConnectionState> emit,
  ) async {
    try {
      final result = await _connectionManager.testConnection();

      if (result.success) {
        if (_connectionManager.currentConfig != null) {
          emit(
            ConnectionConnected(
              config: _connectionManager.currentConfig!,
              details: result.data,
            ),
          );
        }
      } else {
        emit(ConnectionError(message: result.message, exception: result.error));
      }
    } catch (e) {
      emit(
        ConnectionError(
          message: 'Connection test failed: ${e.toString()}',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  Future<void> _onRetry(
    ConnectionRetryRequested event,
    Emitter<BackendConnectionState> emit,
  ) async {
    if (_lastConfig != null) {
      await _onConnectBackend(
        ConnectionBackendConnectRequested(_lastConfig!),
        emit,
      );
    } else {
      await _connectEnvironment(emit);
    }
  }

  void _onDisconnect(
    ConnectionDisconnectRequested event,
    Emitter<BackendConnectionState> emit,
  ) {
    _connectionManager.disconnect();
    emit(const ConnectionDisconnected());
  }

  Future<void> _onSwitch(
    ConnectionSwitchRequested event,
    Emitter<BackendConnectionState> emit,
  ) async {
    _connectionManager.disconnect();
    emit(const ConnectionDisconnected());
    await _onConnectBackend(
      ConnectionBackendConnectRequested(event.config),
      emit,
    );
  }

  List<BackendConfig> get availableConfigs =>
      _connectionManager.predefinedConfigs;

  Map<String, dynamic> get connectionDetails =>
      _connectionManager.getConnectionDetails();

  bool get isConnected => _connectionManager.isConnected;
}
