import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:stridelog/models/user.dart';
import 'package:stridelog/services/local_storage_service.dart';

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
      final users = await LocalStorageService.getUsers();
      
      if (users.any((user) => user.email == email)) {
        return false; // Email already exists
      }

      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        hashedPassword: _hashPassword(password),
        createdAt: DateTime.now(),
      );

      users.add(user);
      await LocalStorageService.saveUsers(users);
      
      _currentUser = user;
      await LocalStorageService.setCurrentUserId(user.id);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      final users = await LocalStorageService.getUsers();
      final hashedPassword = _hashPassword(password);

      final user = users.where((u) => u.email == email && u.hashedPassword == hashedPassword).firstOrNull;
      
      if (user != null) {
        _currentUser = user;
        await LocalStorageService.setCurrentUserId(user.id);
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logout() async {
    _currentUser = null;
    await LocalStorageService.setCurrentUserId(null);
  }

  static Future<bool> isLoggedIn() async {
    try {
      final userId = await LocalStorageService.getCurrentUserId();
      if (userId == null) return false;

      final users = await LocalStorageService.getUsers();
      _currentUser = users.where((u) => u.id == userId).firstOrNull;
      
      return _currentUser != null;
    } catch (e) {
      return false;
    }
  }
}