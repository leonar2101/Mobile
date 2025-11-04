import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:stridelog/models/user.dart';
import 'package:stridelog/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static User? _currentUser;
  static User? get currentUser => _currentUser;

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<bool> register(String name, String email, String password) async {
    try {
      final existingUser = await DatabaseService.getUserByEmail(email);
      if (existingUser != null) return false;

      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        hashedPassword: _hashPassword(password),
        createdAt: DateTime.now(),
      );

      await DatabaseService.insertUser(user);
      _currentUser = user;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentUserId', user.id);

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      final user = await DatabaseService.getUserByEmail(email);
      if (user == null) return false;

      final hashedPassword = _hashPassword(password);
      if (user.hashedPassword != hashedPassword) return false;

      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentUserId', user.id);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUserId');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('currentUserId');
    if (id == null) return false;

    final user = await DatabaseService.getUserById(id);
    _currentUser = user;
    return user != null;
  }
}
