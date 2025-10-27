import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart'; // adjust path as needed

class UserService {
  static const String _userKey = 'user_data';

  /// Save user session
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  /// Retrieve user session
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(_userKey);

    if (userJson != null) {
      try {
        Map<String, dynamic> userMap = jsonDecode(userJson);
        return User.fromJson(userMap);
      } catch (e) {
        // handle corrupted JSON gracefully
        await prefs.remove(_userKey);
        return null;
      }
    }
    return null;
  }

  /// Check if a user is already logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userKey);
  }

  /// Clear user session (logout)
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  /// Update specific field (optional helper)
  static Future<void> updateField(String key, dynamic value) async {
    final user = await getUser();
    if (user == null) return;
    final data = user.toJson();
    data[key] = value;
    await saveUser(User.fromJson(data));
  }
}
