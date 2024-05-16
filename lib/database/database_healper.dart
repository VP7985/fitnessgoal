import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fitnessgoal/models/habit.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'habits.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE habits(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, date TEXT, time TEXT)",
        );
      },
    );
  }

  Future<void> insertHabit(Habit habit) async {
    final db = await database;
    await db.insert(
      'habits',
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Habit>> getHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (i) {
      return Habit(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        date: maps[i]['date'],
        time: maps[i]['time'],
      );
    });
  }

  Future<void> updateHabit(Habit habit) async {
    final db = await database;
    await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<void> deleteHabit(int id) async {
    final db = await database;
    await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
