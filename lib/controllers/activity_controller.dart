import 'package:flutter/foundation.dart';
import 'package:stridelog/models/activity.dart';
import 'package:stridelog/services/database_service.dart';
import 'package:stridelog/controllers/auth_controller.dart';

class ActivityController {
  static final ValueNotifier<int> activityVersion = ValueNotifier<int>(0);
  static void _bumpVersion() => activityVersion.value++;

  static Future<List<Activity>> getUserActivities() async {
    final user = AuthController.currentUser;
    if (user == null) return [];
    final activities = await DatabaseService.getActivitiesByUser(user.id);
    return activities;
  }

  static Future<bool> addActivity(Activity activity) async {
    try {
      await DatabaseService.insertActivity(activity);
      _bumpVersion();
      return true;
    } catch (e) {
      debugPrint('Erro ao adicionar atividade: $e');
      return false;
    }
  }

  static Future<bool> updateActivity(Activity activity) async {
    try {
      await DatabaseService.updateActivity(activity);
      _bumpVersion();
      return true;
    } catch (e) {
      debugPrint('Erro ao atualizar atividade: $e');
      return false;
    }
  }

  static Future<bool> deleteActivity(String id) async {
    try {
      await DatabaseService.deleteActivity(id);
      _bumpVersion();
      return true;
    } catch (e) {
      debugPrint('Erro ao deletar atividade: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> getStatistics() async {
    final activities = await getUserActivities();

    if (activities.isEmpty) {
      return {
        'totalActivities': 0,
        'totalTime': 0,
        'totalDistance': 0.0,
        'totalCalories': 0,
        'averagePerWeek': 0.0,
      };
    }

    final totalTime = activities.fold(0, (sum, a) => sum + a.durationMinutes);
    final totalDistance = activities.fold(0.0, (sum, a) => sum + (a.distanceKm ?? 0));
    final totalCalories = activities.fold(0, (sum, a) => sum + (a.calories ?? 0));

    final oldest = activities.last.date;
    final weeks = DateTime.now().difference(oldest).inDays / 7;
    final avg = weeks > 0 ? activities.length / weeks : 0.0;

    return {
      'totalActivities': activities.length,
      'totalTime': totalTime,
      'totalDistance': totalDistance,
      'totalCalories': totalCalories,
      'averagePerWeek': avg,
    };
  }
}
