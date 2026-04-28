# Write Tests

Write unit or widget tests for existing code following project conventions.

## When to Use

- User says "write tests", "add tests", "test this"
- After implementing a use case, repository, or BLoC
- To verify a bug fix with a regression test

## Test Types

### Use Case Tests (unit)

File: `test/features/<feature>/domain/usecases/<name>_usecase_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class Mock<FeatureRepository> extends Mock implements <FeatureRepository> {}

void main() {
  late <UseCase> useCase;
  late Mock<FeatureRepository> mockRepository;

  setUp(() {
    mockRepository = Mock<FeatureRepository>();
    useCase = <UseCase>(repository: mockRepository);
  });

  group('<UseCase>', () {
    test('returns data on success', () async {
      // Arrange
      when(() => mockRepository.<method>())
          .thenAnswer((_) async => Right(<mockData>));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, Right(<mockData>));
      verify(() => mockRepository.<method>()).called(1);
    });

    test('returns failure on error', () async {
      // Arrange
      when(() => mockRepository.<method>())
          .thenAnswer((_) async => Left(ServerFailure(message: 'Error')));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result.isLeft(), true);
    });
  });
}
```

### BLoC Tests (unit)

File: `test/features/<feature>/presentation/bloc/<name>_bloc_test.dart`

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class Mock<UseCase> extends Mock implements <UseCase> {}

void main() {
  late <FeatureBloc> bloc;
  late Mock<UseCase> mockUseCase;

  setUp(() {
    mockUseCase = Mock<UseCase>();
    bloc = <FeatureBloc>(useCase: mockUseCase);
  });

  tearDown(() => bloc.close());

  group('<FeatureBloc>', () {
    blocTest<FeatureBloc, FeatureState>(
      'emits [Loading, Loaded] on success',
      build: () {
        when(() => mockUseCase(any()))
            .thenAnswer((_) async => Right(<mockData>));
        return bloc;
      },
      act: (bloc) => bloc.add(const Load<Feature>()),
      expect: () => [
        isA<FeatureLoading>(),
        isA<FeatureLoaded>(),
      ],
    );

    blocTest<FeatureBloc, FeatureState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(() => mockUseCase(any()))
            .thenAnswer((_) async => Left(ServerFailure(message: 'Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const Load<Feature>()),
      expect: () => [
        isA<FeatureLoading>(),
        isA<FeatureError>(),
      ],
    );
  });
}
```

### Repository Tests (unit)

File: `test/features/<feature>/data/repositories/<name>_repository_impl_test.dart`

- Mock the data source
- Test success → returns `Right(data)`
- Test `AuthException` → returns `Left(AuthFailure)`
- Test `NetworkException` → returns `Left(NetworkFailure)`
- Test `ServerException` → returns `Left(ServerFailure)`

### Widget Tests

File: `test/features/<feature>/presentation/pages/<name>_page_test.dart`

```dart
void main() {
  testWidgets('shows loading indicator initially', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => mockBloc,
          child: const <FeaturePage>(),
        ),
      ),
    );
    expect(find.byType(AppLoading), findsOneWidget);
  });
}
```

### Offline-First BLoC Tests

When the BLoC uses `CachePolicy` or `OfflineQueue`, add these scenarios:

```dart
// Mock connectivity
class MockConnectivityCubit extends MockCubit<ConnectivityState>
    implements ConnectivityCubit {}

class MockOfflineQueue extends Mock implements OfflineQueue {}

// Cache policy: returns cached data when fresh
blocTest<FeatureBloc, FeatureState>(
  'emits Loaded from cache when CacheTier.fresh',
  build: () {
    // stub data source to return snapshot with recent cachedAt
    return bloc;
  },
  act: (bloc) => bloc.add(const Load<Feature>()),
  expect: () => [isA<FeatureLoaded>()], // no Loading emitted
);

// Offline write: enqueues instead of calling API
blocTest<FeatureBloc, FeatureState>(
  'emits Queued and enqueues action when offline',
  build: () {
    when(() => mockConnectivityCubit.state)
        .thenReturn(const ConnectivityState.offline());
    return bloc;
  },
  act: (bloc) => bloc.add(const Submit<Feature>(data: testData)),
  expect: () => [isA<FeatureQueued>()],
  verify: (_) {
    verify(() => mockOfflineQueue.enqueue(any())).called(1);
  },
);
```

## Instructions

1. Identify what type of test is needed (use case / BLoC / repo / widget)
2. Create the test file in the correct `test/` directory mirroring the `lib/` structure
3. Use `mocktail` for mocking (not `mockito`)
4. Use `bloc_test` for BLoC tests
5. Cover: success path, failure path, edge cases
6. Run: `flutter test path/to/test_file.dart`

## Rules

- Mirror the `lib/` directory structure under `test/`
- Use `mocktail` — never `mockito`
- Every test group must have a `setUp` and `tearDown` (for BLoC: `bloc.close()`)
- Assert on specific state types with `isA<>()` for BLoC tests
