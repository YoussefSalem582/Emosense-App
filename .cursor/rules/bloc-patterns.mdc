---
description: "BLoC/Cubit state management patterns and conventions"
globs: "technology_ninety_two_app/lib/features/**/bloc/**/*.dart,technology_ninety_two_app/lib/features/**/cubit/**/*.dart"
alwaysApply: false
---

# BLoC & Cubit Patterns

## File Organization

Each BLoC/Cubit has separate files:
- `<name>_bloc.dart` — The BLoC class
- `<name>_event.dart` — Event classes (BLoC only)
- `<name>_state.dart` — State classes

## Event Pattern

```dart
abstract class FeatureEvent extends Equatable {
  const FeatureEvent();
  @override
  List<Object?> get props => [];
}

class LoadData extends FeatureEvent {}

class ActionWithParams extends FeatureEvent {
  final int id;
  const ActionWithParams({required this.id});
  @override
  List<Object?> get props => [id];
}
```

## State Pattern

```dart
abstract class FeatureState extends Equatable {
  const FeatureState();
  @override
  List<Object?> get props => [];
}

class FeatureInitial extends FeatureState {}
class FeatureLoading extends FeatureState {}
class FeatureLoaded extends FeatureState {
  final DataType data;
  const FeatureLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}
class FeatureError extends FeatureState {
  final String message;
  const FeatureError({required this.message});
  @override
  List<Object?> get props => [message];
}
```

## BLoC Pattern

```dart
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final SomeUseCase someUseCase;

  FeatureBloc({required this.someUseCase}) : super(FeatureInitial()) {
    on<LoadData>(_onLoad);
  }

  Future<void> _onLoad(LoadData event, Emitter<FeatureState> emit) async {
    emit(FeatureLoading());
    final result = await someUseCase(params);
    result.fold(
      (failure) => emit(FeatureError(message: failure.message)),
      (data) => emit(FeatureLoaded(data: data)),
    );
  }

  @override
  void onTransition(Transition<FeatureEvent, FeatureState> transition) {
    AppLogger.logBlocTransition('FeatureBloc', transition.event, transition.currentState);
    super.onTransition(transition);
  }
}
```

## UI Usage

- `BlocBuilder<Bloc, State>` for rebuilding UI on state changes
- `BlocListener<Bloc, State>` for side effects (navigation, snackbars)
- `BlocConsumer` when you need both
- Access BLoC via `context.read<FeatureBloc>()` for events
- Access state via `context.watch<FeatureBloc>().state` in build methods
