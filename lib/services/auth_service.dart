import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/database_helper.dart';

class AuthService {
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  static Future<bool> register(String name, String email, String password) async {
    final db = await DatabaseHelper.open();

    try {
      await db.insert('users', {
        'name': name,
        'email': email,
        'password': _hashPassword(password),
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    final db = await DatabaseHelper.open();
    final hashed = _hashPassword(password);

    final user = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashed],
    );

    if (user.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userName', user.first['name'] as String);
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
