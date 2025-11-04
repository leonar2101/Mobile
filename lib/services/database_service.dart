import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stridelog/models/user.dart';
import 'package:stridelog/models/activity.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _openDb();
    return _db!;
  }

  static Future<Database> _openDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'stridelog.db');

    return openDatabase(
      path,
      version: 2, // ← incrementa versão para recriar com nova tabela
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE custom_activity_types (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              userId TEXT NOT NULL,
              name TEXT NOT NULL
            );
          ''');
        }
      },
    );
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        hashedPassword TEXT NOT NULL,
        createdAt TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE activities (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        type TEXT NOT NULL,
        customTypeName TEXT,
        durationMinutes INTEGER NOT NULL,
        distanceKm REAL,
        calories INTEGER,
        date TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE custom_activity_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        name TEXT NOT NULL
      );
    ''');
  }


  static Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  static Future<User?> getUserById(String id) async {
    final db = await database;
    final res = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  static Future<void> insertActivity(Activity activity) async {
    final db = await database;
    await db.insert('activities', activity.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Activity>> getActivitiesByUser(String userId) async {
    final db = await database;
    final maps = await db.query(
      'activities',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Activity.fromJson(maps[i]));
  }

  static Future<void> updateActivity(Activity activity) async {
    final db = await database;
    await db.update('activities', activity.toJson(),
        where: 'id = ?', whereArgs: [activity.id]);
  }

  static Future<void> deleteActivity(String id) async {
    final db = await database;
    await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> addCustomActivityType(String userId, String name) async {
    final db = await database;
    await db.insert('custom_activity_types', {
      'userId': userId,
      'name': name,
    });
  }

  static Future<List<String>> getCustomActivityTypes(String userId) async {
    final db = await database;
    final res = await db.query(
      'custom_activity_types',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'name ASC',
    );
    return res.map((e) => e['name'] as String).toList();
  }

  static Future<void> deleteCustomType(String userId, String name) async {
    final db = await database;
    await db.delete(
      'custom_activity_types',
      where: 'userId = ? AND name = ?',
      whereArgs: [userId, name],
    );
  }

  static Future<void> clearAll() async {
    final db = await database;
    await db.delete('activities');
    await db.delete('custom_activity_types');
    await db.delete('users');
  }
}
