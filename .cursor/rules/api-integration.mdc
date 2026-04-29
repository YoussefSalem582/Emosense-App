---
description: "API integration patterns — endpoints, data sources, response parsing, error handling"
alwaysApply: false
---

# API Integration

## Adding a New Endpoint

1. Define path in `lib/core/api/api_endpoints.dart`
   - Static: `static const String name = '/path';`
   - Dynamic: `static String name(int id) => '/path/$id';`
   - Group related endpoints under comment banners
   - Paths do NOT include base URL or `/api/v1` prefix (handled by ApiClient)

2. Add HTTP call to remote data source using `ApiClient`
3. Parse response with `ApiResponse.fromJson()`
4. Create/update model with `fromJson`/`toJson`
5. Add method to domain repository contract (returns `Either<Failure, T>`)
6. Implement in repository impl with exception-to-failure mapping
7. Create use case
8. Wire into BLoC
9. Register in `injection_container.dart`

## ApiClient Methods

| Method | Signature |
|--------|-----------|
| GET | `apiClient.get(path, {queryParameters})` |
| POST | `apiClient.post(path, {data})` |
| PUT | `apiClient.put(path, {data})` |
| PATCH | `apiClient.patch(path, {data})` |
| DELETE | `apiClient.delete(path)` |
| Upload | `apiClient.uploadFile(path, {file, fieldName, data})` |

All return `Response<dynamic>`. Parse with `ApiResponse.fromJson()`.

## Backend Response Format

Success: `{ "success": true, "message": "...", "data": ..., "pagination": {...} }`
Error: `{ "success": false, "message": "...", "errors": {} }`
Validation (422): `{ "message": "...", "errors": { "field": ["msg"] } }`

## Error Flow

API error → `ApiClient` catches `DioException` → maps to Exception (`ServerException`, `AuthException`, `NetworkException`) → Repository catches Exception → maps to Failure → wrapped in `Left<Failure, T>` → BLoC folds into error state → UI displays error

## Interceptors (automatic)

1. **Auth**: Adds `Authorization: Bearer <token>` from SecureStorage
2. **Language**: Adds `lang` and `Accept-Language` headers
3. **Logging**: `TalkerDioLogger` (disabled in production)
4. **Retry**: `RetryInterceptor` — auto-retries failed GET requests (2 retries, 1s/3s backoff) on transient network errors and 5xx responses. Mutations are NOT retried; they go through `OfflineQueue`.

## Offline-First

- **Reads**: Wrap fetches with `CachePolicy.evaluate(cachedAt: ...)` — return cached data if fresh/stale, only call API when stale (background) or expired
- **Writes**: Check `ConnectivityCubit` state first; if offline, enqueue via `OfflineQueue` and emit an optimistic state instead of calling the API
- See `core/network/cache_policy.dart` and `core/network/offline_queue.dart`
