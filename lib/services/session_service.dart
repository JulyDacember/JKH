import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class SessionService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userEmailKey = 'userEmail';
  static const String _userRoleKey = 'userRole';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<UserRole> getCurrentRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roleValue = prefs.getString(_userRoleKey);
    return UserRoleX.fromStorageValue(roleValue);
  }

  Future<void> saveLogin({
    required String email,
    required UserRole role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userRoleKey, role.storageValue);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_userRoleKey);
  }
}
