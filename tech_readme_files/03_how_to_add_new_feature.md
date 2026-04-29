# ✨ How to Add a New Feature

> Step-by-step guide using a hypothetical **Notifications** feature as the example.

---

## Overview of Steps

| # | What | Where |
|---|------|-------|
| 1 | Create folder structure | `lib/features/notifications/` |
| 2 | Domain layer — Entity | `domain/entities/` |
| 3 | Domain layer — Repository contract | `domain/repositories/` |
| 4 | Domain layer — Use Cases | `domain/usecases/` |
| 5 | Data layer — Model | `data/models/` |
| 6 | Data layer — Data Source | `data/datasources/` |
| 7 | Data layer — Repository impl | `data/repositories/` |
| 8 | Presentation layer — Events & States | `presentation/bloc/` |
| 9 | Presentation layer — BLoC | `presentation/bloc/` |
| 10 | Presentation layer — Pages & Widgets | `presentation/pages/`, `presentation/widgets/` |
| 11 | Register in DI | `injection_container.dart` |
| 12 | Add route | `config/routes/` |
| 13 | Add translations | `l10n/arb/` |

---

## Step 1 — Create the Folder Structure

```
lib/features/notifications/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

---

## Step 2 — Domain Entity

Create `lib/features/notifications/domain/entities/notification_entity.dart`:

```dart
import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, body, isRead, createdAt];
}
```

**Rules:**
- Extend `Equatable`.
- No Flutter imports — pure Dart only.
- No `fromJson` / `toJson` — that belongs in the Model.

---

## Step 3 — Domain Repository (Contract)

Create `lib/features/notifications/domain/repositories/notifications_repository.dart`:

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notification_entity.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({int page = 1});
  Future<Either<Failure, void>> markAsRead(int notificationId);
  Future<Either<Failure, int>> getUnreadCount();
}
```

**Rules:**
- Abstract class only.
- Return `Either<Failure, T>` for every method.
- No implementation details — just the contract.

---

## Step 4 — Domain Use Cases

Create one file per operation:

**`lib/features/notifications/domain/usecases/get_notifications_usecase.dart`:**

```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/notification_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsUseCase
    extends UseCase<List<NotificationEntity>, GetNotificationsParams> {
  final NotificationsRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
      GetNotificationsParams params) {
    return repository.getNotifications(page: params.page);
  }
}

class GetNotificationsParams extends Equatable {
  final int page;
  const GetNotificationsParams({this.page = 1});

  @override
  List<Object?> get props => [page];
}
```

**`lib/features/notifications/domain/usecases/mark_as_read_usecase.dart`:**

```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/notifications_repository.dart';

class MarkAsReadUseCase extends UseCase<void, MarkAsReadParams> {
  final NotificationsRepository repository;

  MarkAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkAsReadParams params) {
    return repository.markAsRead(params.notificationId);
  }
}

class MarkAsReadParams extends Equatable {
  final int notificationId;
  const MarkAsReadParams({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}
```

---

## Step 5 — Data Model

Create `lib/features/notifications/data/models/notification_model.dart`:

```dart
import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'is_read': isRead,
        'created_at': createdAt.toIso8601String(),
      };
}
```

**Rules:**
- Extends the entity — inherits Equatable.
- `fromJson` maps the **backend snake_case** JSON keys.
- `toJson` reverses the mapping.

---

## Step 6 — Data Source

Create `lib/features/notifications/data/datasources/notifications_remote_datasource.dart`:

```dart
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/api/api_response.dart';
import '../models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({int page = 1});
  Future<void> markAsRead(int notificationId);
  Future<int> getUnreadCount();
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final ApiClient apiClient;

  NotificationsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<NotificationModel>> getNotifications({int page = 1}) async {
    final response = await apiClient.get(
      ApiEndpoints.notifications,             // <-- add to api_endpoints.dart
      queryParameters: {'page': page},
    );
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response.data,
      (d) => d as List<dynamic>,
    );
    return apiResponse.data!
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    await apiClient.post(ApiEndpoints.markNotificationRead(notificationId));
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await apiClient.get(ApiEndpoints.unreadNotificationCount);
    return (response.data['data'] as int?) ?? 0;
  }
}
```

> **Don't forget** to add the new endpoints to `lib/core/api/api_endpoints.dart` — see the [How to Add a New API](./04_how_to_add_new_api.md) guide.

---

## Step 7 — Repository Implementation

Create `lib/features/notifications/data/repositories/notifications_repository_impl.dart`:

```dart
import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_datasource.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({int page = 1}) async {
    try {
      final result = await remoteDataSource.getNotifications(page: page);
      return Right(result);
    } on AuthException {
      return const Left(AuthFailure(message: 'Session expired'));
    } on NetworkException {
      return const Left(NetworkFailure(message: 'No internet connection'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  // ... repeat pattern for markAsRead, getUnreadCount
}
```

**Copy-paste the try/catch pattern** from any existing repository impl. The exception types should always match.

---

## Step 8 — BLoC Events & States

**`lib/features/notifications/presentation/bloc/notifications_event.dart`:**

```dart
import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationsEvent {}

class LoadMoreNotifications extends NotificationsEvent {}

class MarkNotificationRead extends NotificationsEvent {
  final int notificationId;
  const MarkNotificationRead({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}
```

**`lib/features/notifications/presentation/bloc/notifications_state.dart`:**

```dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> notifications;
  final bool hasMore;

  const NotificationsLoaded({required this.notifications, this.hasMore = true});

  @override
  List<Object?> get props => [notifications, hasMore];
}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError({required this.message});

  @override
  List<Object?> get props => [message];
}
```

---

## Step 9 — BLoC

Create `lib/features/notifications/presentation/bloc/notifications_bloc.dart`:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_as_read_usecase.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkAsReadUseCase markAsReadUseCase;

  NotificationsBloc({
    required this.getNotificationsUseCase,
    required this.markAsReadUseCase,
  }) : super(NotificationsInitial()) {
    on<LoadNotifications>(_onLoad);
    on<MarkNotificationRead>(_onMarkRead);
  }

  Future<void> _onLoad(LoadNotifications event, Emitter<NotificationsState> emit) async {
    emit(NotificationsLoading());
    final result = await getNotificationsUseCase(
      const GetNotificationsParams(page: 1),
    );
    result.fold(
      (failure) => emit(NotificationsError(message: failure.message)),
      (notifications) => emit(NotificationsLoaded(notifications: notifications)),
    );
  }

  Future<void> _onMarkRead(MarkNotificationRead event, Emitter<NotificationsState> emit) async {
    await markAsReadUseCase(MarkAsReadParams(notificationId: event.notificationId));
    // Reload list after marking read
    add(LoadNotifications());
  }

  @override
  void onTransition(Transition<NotificationsEvent, NotificationsState> transition) {
    AppLogger.logBlocTransition('NotificationsBloc', transition.event, transition.currentState);
    super.onTransition(transition);
  }
}
```

---

## Step 10 — Pages & Widgets

Create your page widgets under `presentation/pages/` and any feature-specific widgets under `presentation/widgets/`.

Use shared widgets from `lib/shared/widgets/` for common UI (buttons, inputs, loading, error, etc.).

---

## Step 11 — Register in DI

Open `lib/injection_container.dart` and add a new init function:

```dart
// At the end of initDependencies():
_initNotifications();

// New function:
void _initNotifications() {
  // Data Sources
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkAsReadUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => NotificationsBloc(
      getNotificationsUseCase: sl(),
      markAsReadUseCase: sl(),
    ),
  );
}
```

Don't forget to add the `BlocProvider` in `app.dart`:

```dart
BlocProvider<NotificationsBloc>(create: (_) => sl<NotificationsBloc>()),
```

---

## Step 12 — Add Route

**`lib/config/routes/route_names.dart`** — add the constant:

```dart
static const String notifications = 'notifications';
```

**`lib/config/routes/app_router.dart`** — add the route:

```dart
GoRoute(
  path: '/notifications',
  name: RouteNames.notifications,
  pageBuilder: (context, state) =>
      _buildPage(state: state, child: const NotificationsPage()),
),
```

---

## Step 13 — Add Translations

Add keys to **both** `lib/l10n/arb/app_en.arb` and `lib/l10n/arb/app_ar.arb`:

```json
"notificationsTitle": "Notifications",
"noNotifications": "No notifications yet",
"markAllRead": "Mark all as read"
```

Then run:

```bash
flutter gen-l10n
```

---

## Checklist

- [ ] Domain: Entity created (extends Equatable)
- [ ] Domain: Repository contract created (abstract, returns Either)
- [ ] Domain: Use cases created (one per operation)
- [ ] Data: Model created (extends Entity, fromJson/toJson)
- [ ] Data: Remote data source created (uses ApiClient)
- [ ] Data: Repository impl created (maps exceptions → failures)
- [ ] Presentation: Events created (extends Equatable)
- [ ] Presentation: States created (extends Equatable)
- [ ] Presentation: BLoC created (calls use cases, logs transitions)
- [ ] Presentation: Pages created
- [ ] DI: All classes registered in `injection_container.dart`
- [ ] DI: BlocProvider added to `app.dart`
- [ ] Route: Name added to `route_names.dart`
- [ ] Route: GoRoute added to `app_router.dart`
- [ ] Endpoints: Added to `api_endpoints.dart`
- [ ] Translations: Keys added to both ARB files
- [ ] `flutter gen-l10n` run successfully
