import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stridelog/models/user.dart';
import 'package:stridelog/models/activity.dart';

class LocalStorageService {
  static const String _usersKey = 'users';
  static const String _activitiesKey = 'activities';
  static const String _currentUserKey = 'current_user_id';

  static Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  static Future<List<User>> getUsers() async {
    final prefs = await _prefs;
    final usersJson = prefs.getString(_usersKey) ?? '[]';
    final List<dynamic> usersList = jsonDecode(usersJson);
    return usersList.map((json) => User.fromJson(json)).toList();
  }

  static Future<void> saveUsers(List<User> users) async {
    final prefs = await _prefs;
    final usersJson = jsonEncode(users.map((u) => u.toJson()).toList());
    await prefs.setString(_usersKey, usersJson);
  }

  static Future<List<Activity>> getActivities() async {
    final prefs = await _prefs;
    final activitiesJson = prefs.getString(_activitiesKey) ?? '[]';
    final List<dynamic> activitiesList = jsonDecode(activitiesJson);
    return activitiesList.map((json) => Activity.fromJson(json)).toList();
  }

  static Future<void> saveActivities(List<Activity> activities) async {
    final prefs = await _prefs;
    final activitiesJson = jsonEncode(activities.map((a) => a.toJson()).toList());
    await prefs.setString(_activitiesKey, activitiesJson);
  }

  static Future<String?> getCurrentUserId() async {
    final prefs = await _prefs;
    return prefs.getString(_currentUserKey);
  }

  static Future<void> setCurrentUserId(String? userId) async {
    final prefs = await _prefs;
    if (userId != null) {
      await prefs.setString(_currentUserKey, userId);
    } else {
      await prefs.remove(_currentUserKey);
    }
  }

  // Custom activity types per user
  static String _customTypesKeyFor(String userId) => 'custom_types_' + userId;

  static Future<List<String>> getCustomActivityTypes(String userId) async {
    final prefs = await _prefs;
    final raw = prefs.getString(_customTypesKeyFor(userId)) ?? '[]';
    final List<dynamic> list = jsonDecode(raw);
    return list.map((e) => e.toString()).toList();
  }

  static Future<void> saveCustomActivityTypes(String userId, List<String> types) async {
    final prefs = await _prefs;
    await prefs.setString(_customTypesKeyFor(userId), jsonEncode(types));
  }

  static Future<void> addCustomActivityType(String userId, String typeName) async {
    final types = await getCustomActivityTypes(userId);
    if (!types.contains(typeName)) {
      types.add(typeName);
      await saveCustomActivityTypes(userId, types);
    }
  }

  static Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.clear();
  }
}