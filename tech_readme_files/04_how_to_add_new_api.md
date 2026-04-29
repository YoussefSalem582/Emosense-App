# 🔌 How to Add a New API

> Guide for connecting a new backend endpoint end-to-end.

---

## Overview

Adding a new API call touches these files (in order):

| # | File | What to do |
|---|------|-----------|
| 1 | `lib/core/api/api_endpoints.dart` | Define the endpoint path |
| 2 | `data/datasources/*_remote_datasource.dart` | Add the HTTP call |
| 3 | `data/models/*_model.dart` | Add/update the model if response shape is new |
| 4 | `domain/entities/*_entity.dart` | Add/update the entity if new fields appear |
| 5 | `domain/repositories/*_repository.dart` | Add the method to the abstract contract |
| 6 | `data/repositories/*_repository_impl.dart` | Implement the method |
| 7 | `domain/usecases/` | Create a new use case |
| 8 | `presentation/bloc/` | Add event + state + handler |
| 9 | `lib/core/di/dependency_injection.dart` | Register the new use case |

---

## Step 1 — Define the Endpoint

Open `lib/core/api/api_endpoints.dart` and add the path.

**For static endpoints:**

```dart
// ─── Notifications ──────────────────────────────────────
static const String notifications = '/notifications';
static const String unreadNotificationCount = '/notifications/unread-count';
```

**For dynamic endpoints (with path parameters):**

```dart
static String markNotificationRead(int id) => '/notifications/$id/read';
```

**Conventions:**
- Group related endpoints under a comment banner.
- Use `static const String` for fixed paths.
- Use `static String methodName(Type param)` for dynamic paths.
- Paths do NOT include the base URL or `/api/v1` prefix — those are prepended by `ApiClient`.

---

## Step 2 — Add the HTTP Call to the Data Source

Open (or create) the remote data source file.

### GET request (single item)

```dart
@override
Future<NotificationModel> getNotification(int id) async {
  final response = await apiClient.get(ApiEndpoints.notification(id));
  final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
    response.data,
    (d) => d as Map<String, dynamic>,
  );
  return NotificationModel.fromJson(apiResponse.data!);
}
```

### GET request (paginated list)

```dart
@override
Future<List<NotificationModel>> getNotifications({int page = 1}) async {
  final response = await apiClient.get(
    ApiEndpoints.notifications,
    queryParameters: {'page': page, 'per_page': AppConstants.defaultPageSize},
  );
  final apiResponse = ApiResponse<List<dynamic>>.fromJson(
    response.data,
    (d) => d as List<dynamic>,
  );
  return apiResponse.data!
      .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
      .toList();
}
```

### POST request (with body)

```dart
@override
Future<void> markAsRead(int notificationId) async {
  await apiClient.post(
    ApiEndpoints.markNotificationRead(notificationId),
  );
}
```

### PUT/PATCH request (update)

```dart
@override
Future<ProfileModel> updateProfile(Map<String, dynamic> data) async {
  final response = await apiClient.put(
    ApiEndpoints.applicantProfile,
    data: data,
  );
  final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
    response.data,
    (d) => d as Map<String, dynamic>,
  );
  return ProfileModel.fromJson(apiResponse.data!);
}
```

### File upload

```dart
@override
Future<String> uploadImage(File file) async {
  final response = await apiClient.uploadFile(
    ApiEndpoints.uploadImage,
    file: file,
    fieldName: 'image',
  );
  return response.data['data']['url'] as String;
}
```

---

## Step 3 — Add/Update the Model

If the API returns a new data shape, create or update the model:

```dart
class NotificationModel extends NotificationEntity {
  const NotificationModel({...});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      // Map every field from the backend's snake_case JSON
    );
  }
}
```

---

## Step 4 — Update Domain Contract

Add the new method signature to the abstract repository:

```dart
abstract class NotificationsRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({int page = 1});
  Future<Either<Failure, void>> markAsRead(int notificationId);  // ← NEW
}
```

---

## Step 5 — Implement in Repository

Add implementation with exception-to-failure mapping:

```dart
@override
Future<Either<Failure, void>> markAsRead(int notificationId) async {
  try {
    await remoteDataSource.markAsRead(notificationId);
    return const Right(null);
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
```

---

## Step 6 — Create Use Case

```dart
class MarkAsReadUseCase extends UseCase<void, MarkAsReadParams> {
  final NotificationsRepository repository;
  MarkAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkAsReadParams params) {
    return repository.markAsRead(params.notificationId);
  }
}
```

---

## Step 7 — Wire into BLoC

Add an event, handle it in the BLoC, and optionally add a new state.

---

## Step 8 — Register in DI

In `lib/core/di/dependency_injection.dart`:

```dart
sl.registerLazySingleton(() => MarkAsReadUseCase(sl()));
```

Update the BLoC factory to inject the new use case.

---

## API Response Format Reference

The backend returns a standardised envelope:

### Success

```json
{
  "success": true,
  "message": "Notifications fetched successfully",
  "data": [ ... ],
  "pagination": {
    "current_page": 1,
    "last_page": 5,
    "per_page": 15,
    "total": 72,
    "from": 1,
    "to": 15
  }
}
```

### Error

```json
{
  "success": false,
  "message": "Unauthenticated.",
  "errors": {}
}
```

### Validation Error (422)

```json
{
  "message": "The given data was invalid.",
  "errors": {
    "email": ["The email field is required."],
    "password": ["The password must be at least 8 characters."]
  }
}
```

These are automatically parsed by `ApiClient._handleBadResponse()` into the appropriate exception type.

---

## ApiClient Method Reference

| Method | Signature |
|--------|-----------|
| GET | `apiClient.get(path, {queryParameters})` |
| POST | `apiClient.post(path, {data})` |
| PUT | `apiClient.put(path, {data})` |
| PATCH | `apiClient.patch(path, {data})` |
| DELETE | `apiClient.delete(path)` |
| Upload | `apiClient.uploadFile(path, {file, fieldName, data})` |

All methods return `Response<dynamic>`. Use `ApiResponse.fromJson()` to parse the envelope.
