import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/domain/entities/user_entity.dart';

class AuthLocalStorage {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  // ✅ Save token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // ✅ Get token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // ✅ Save full user entity
  Future<void> saveUser(UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = jsonEncode({
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'accessToken': user.accessToken,
      'refreshToken': user.refreshToken,
    });
    await prefs.setString(_userKey, jsonData);
  }

  // ✅ Get full user entity
  Future<UserEntity?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_userKey);
    if (jsonData == null) return null;

    final Map<String, dynamic> map = jsonDecode(jsonData);
    return UserEntity(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      accessToken: map['accessToken'] ?? '',
      refreshToken: map['refreshToken'] ?? '',
    );
  }

  // ✅ Clear everything
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}
