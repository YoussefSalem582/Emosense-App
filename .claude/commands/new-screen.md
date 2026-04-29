# New Screen

Scaffold a new page + BLoC inside an existing feature. Use this when adding a screen to a feature that already exists — not for brand-new features (use /add-feature for that).

## When to Use

- User says "add screen", "new page", "add a page to [feature]"
- Adding a second/third screen to an existing feature module
- The feature folder already exists with domain + data layers

## Instructions

Ask the user for:
1. **Feature name** — which existing feature this screen belongs to (e.g., `jobs`, `profile`)
2. **Screen name** — what the screen is called (e.g., `job_applications`, `edit_avatar`)
3. **Data needed** — what entity/use cases it needs (or "none" for local-only screens)

Then follow these steps:

### Step 1 — Create the Page

File: `lib/features/<feature>/presentation/pages/<screen_name>_page.dart`

```dart
class <ScreenName>Page extends StatelessWidget {
  const <ScreenName>Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<<ScreenName>Bloc>()..add(const Load<ScreenName>()),
      child: const <ScreenName>View(),
    );
  }
}

class <ScreenName>View extends StatelessWidget {
  const <ScreenName>View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.<screenName>Title),
      body: BlocConsumer<<ScreenName>Bloc, <ScreenName>State>(
        listener: (context, state) {
          if (state is <ScreenName>Error) context.showError(state.message);
        },
        builder: (context, state) {
          if (state is <ScreenName>Loading) return const AppLoading();
          if (state is <ScreenName>Loaded) return _buildContent(context, state);
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

### Step 2 — Create BLoC (3 files)

**Event** — `presentation/bloc/<screen_name>_event.dart`:
- `Load<ScreenName>` event (with any required params)

**State** — `presentation/bloc/<screen_name>_state.dart`:
- `<ScreenName>Initial`, `<ScreenName>Loading`, `<ScreenName>Loaded`, `<ScreenName>Error`
- Add `<ScreenName>Queued` if the screen has write operations that can be offline-queued

**BLoC** — `presentation/bloc/<screen_name>_bloc.dart`:
- Inject relevant use cases
- Call use case, fold result into states
- Log transitions with `AppLogger.logBlocTransition()`
- **Reads**: apply `CachePolicy.evaluate(cachedAt: ...)` before every API call
- **Writes**: check connectivity; if offline, enqueue via `OfflineQueue` and emit optimistic state

### Step 3 — Register in DI

In `lib/core/di/dependency_injection.dart`:
```dart
sl.registerFactory(() => <ScreenName>Bloc(useCase: sl()));
```

Add `BlocProvider` in `app.dart` if needed at top level.

### Step 4 — Add Route

Extend **`AppRouter`** (`lib/core/routing/app_router.dart`):

1. Add `static const String <screenPath> = '/<screen-path>'` next to sibling routes.

2. Add a `case` inside `generateRoute` that builds your page:

```dart
case AppRouter.someScreenPath:
  return MaterialPageRoute(
    builder: (_) => const SomeScreen(),
    settings: settings,
  );
```

Remove references to obsolete `GoRoute`, `route_names.dart`, etc.

### Step 5 — Add Translations

Add to `lib/l10n/arb/app_en.arb` and `app_ar.arb`:
```json
"<screenName>Title": "Screen Title"
```

Run: `flutter gen-l10n`

## Post-Completion Checklist

- [ ] Page + View split correctly
- [ ] BLoC registered as `registerFactory`
- [ ] Route added with `AppRouter` constant in `generateRoute`
- [ ] Translations in both ARB files
- [ ] `flutter gen-l10n` executed
- [ ] Read BLoC: `CachePolicy` applied to load handler
- [ ] Write BLoC: `OfflineQueue` used when offline (if applicable)
- [ ] CHANGELOG.md updated
- [ ] DOCUMENTATION_UPDATE_SUMMARY.md updated
- [ ] CURRENT_STATUS.md updated
