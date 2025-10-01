import 'package:flutter/foundation.dart';
import 'package:stridelog/models/activity.dart';
import 'package:stridelog/services/local_storage_service.dart';
import 'package:stridelog/controllers/auth_controller.dart';

class ActivityController {
  // Notifier to broadcast changes in activities (add/update/delete)
  static final ValueNotifier<int> activityVersion = ValueNotifier<int>(0);

  static void _bumpVersion() {
    activityVersion.value++;
  }

  static Future<List<Activity>> getUserActivities() async {
    final currentUser = AuthController.currentUser;
    if (currentUser == null) return [];

    final activities = await LocalStorageService.getActivities();
    final userActivities = activities.where((a) => a.userId == currentUser.id).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    debugPrint('ActivityController.getUserActivities: all=${activities.length} forUser(${currentUser.id})=${userActivities.length}');
    return userActivities;
  }

  static Future<bool> addActivity(Activity activity) async {
    try {
      final activities = await LocalStorageService.getActivities();
      activities.add(activity);
      await LocalStorageService.saveActivities(activities);
      debugPrint('ActivityController.addActivity: saved id=${activity.id} type=${activity.type.name} custom=${activity.customTypeName} total=${activities.length}');
      _bumpVersion();
      return true;
    } catch (e) {
      debugPrint('ActivityController.addActivity: error $e');
      return false;
    }
  }

  static Future<bool> updateActivity(Activity updatedActivity) async {
    try {
      final activities = await LocalStorageService.getActivities();
      final index = activities.indexWhere((a) => a.id == updatedActivity.id);
      
      if (index != -1) {
        activities[index] = updatedActivity;
        await LocalStorageService.saveActivities(activities);
        _bumpVersion();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteActivity(String activityId) async {
    try {
      final activities = await LocalStorageService.getActivities();
      activities.removeWhere((a) => a.id == activityId);
      await LocalStorageService.saveActivities(activities);
      _bumpVersion();
      return true;
    } catch (e) {
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
    
    final oldestActivity = activities.last.date;
    final weeksSinceStart = DateTime.now().difference(oldestActivity).inDays / 7;
    final averagePerWeek = weeksSinceStart > 0 ? activities.length / weeksSinceStart : 0.0;

    return {
      'totalActivities': activities.length,
      'totalTime': totalTime,
      'totalDistance': totalDistance,
      'totalCalories': totalCalories,
      'averagePerWeek': averagePerWeek,
    };
  }

  static Future<void> initializeSampleData() async {
    final currentUser = AuthController.currentUser;
    if (currentUser == null) return;

    final existingActivities = await getUserActivities();
    if (existingActivities.isNotEmpty) return; // Already has data

    final now = DateTime.now();
    final sampleActivities = [
      Activity(
        id: '1',
        userId: currentUser.id,
        type: ActivityType.running,
        durationMinutes: 45,
        distanceKm: 8.2,
        calories: 520,
        date: now.subtract(const Duration(days: 1)),
        notes: 'Corrida matinal no parque',
      ),
      Activity(
        id: '2',
        userId: currentUser.id,
        type: ActivityType.gym,
        durationMinutes: 90,
        calories: 350,
        date: now.subtract(const Duration(days: 2)),
        notes: 'Treino de pernas e glúteos',
      ),
      Activity(
        id: '3',
        userId: currentUser.id,
        type: ActivityType.cycling,
        durationMinutes: 60,
        distanceKm: 15.5,
        calories: 420,
        date: now.subtract(const Duration(days: 3)),
        notes: 'Pedal pela ciclovia da cidade',
      ),
      Activity(
        id: '4',
        userId: currentUser.id,
        type: ActivityType.yoga,
        durationMinutes: 30,
        calories: 120,
        date: now.subtract(const Duration(days: 4)),
        notes: 'Yoga relaxante antes de dormir',
      ),
      Activity(
        id: '5',
        userId: currentUser.id,
        type: ActivityType.walking,
        durationMinutes: 25,
        distanceKm: 2.1,
        calories: 80,
        date: now.subtract(const Duration(days: 5)),
        notes: 'Caminhada rápida na praia',
      ),
    ];

    final allActivities = await LocalStorageService.getActivities();
    allActivities.addAll(sampleActivities);
    await LocalStorageService.saveActivities(allActivities);
    _bumpVersion();
  }
}