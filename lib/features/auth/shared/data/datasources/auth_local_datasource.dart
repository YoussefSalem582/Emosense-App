import 'package:emosense_mobile/core/auth/user_session_storage.dart';
import 'package:emosense_mobile/features/auth/shared/domain/entities/auth_response_entity.dart';
import 'package:emosense_mobile/features/auth/shared/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthData({required AuthResponseEntity response});

  Future<UserEntity?> getCachedUser();

  Future<bool> hasSession();

  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _tokenKey = 'emosense_auth_token';

  @override
  Future<void> cacheAuthData({required AuthResponseEntity response}) async {
    await UserSessionStorage.save(response.user);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, response.token);
  }

  @override
  Future<UserEntity?> getCachedUser() => UserSessionStorage.read();

  @override
  Future<bool> hasSession() async {
    final u = await getCachedUser();
    if (u != null) return true;
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString(_tokenKey);
    return t != null && t.isNotEmpty;
  }

  @override
  Future<void> clearAuthData() async {
    await UserSessionStorage.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
