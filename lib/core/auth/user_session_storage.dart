import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user_entity.dart';

/// Persists [UserEntity] for cold start (login/signup already update [UserBloc]).
class UserSessionStorage {
  UserSessionStorage._();

  static const _key = 'emosense_user_session';

  static Future<void> save(UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_toJson(user)));
  }

  static Future<UserEntity?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return _fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Map<String, dynamic> _toJson(UserEntity u) {
    return {
      'id': u.id,
      'name': u.name,
      'email': u.email,
      'role': u.role.name,
      'avatar': u.avatar,
      'createdAt': u.createdAt.toIso8601String(),
      'preferences': {
        'darkMode': u.preferences.darkMode,
        'language': u.preferences.language,
        'notifications': u.preferences.notifications,
        'timezone': u.preferences.timezone,
      },
    };
  }

  static UserEntity _fromJson(Map<String, dynamic> j) {
    final p = j['preferences'] as Map<String, dynamic>? ?? {};
    return UserEntity(
      id: j['id'] as String,
      name: j['name'] as String,
      email: j['email'] as String,
      role: UserRole.values.byName(j['role'] as String),
      avatar: j['avatar'] as String?,
      createdAt: DateTime.parse(j['createdAt'] as String),
      preferences: UserPreferences(
        darkMode: p['darkMode'] as bool? ?? false,
        language: p['language'] as String? ?? 'en',
        notifications: p['notifications'] as bool? ?? true,
        timezone: p['timezone'] as String? ?? 'UTC',
      ),
    );
  }
}
