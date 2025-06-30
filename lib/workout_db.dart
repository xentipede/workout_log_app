import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../workout.dart';

class WorkoutDatabase {
  static final WorkoutDatabase instance = WorkoutDatabase._init();
  static Database? _database;

  WorkoutDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('workouts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workouts (
        id TEXT PRIMARY KEY,
        exercise TEXT,
        sets INTEGER,
        reps INTEGER,
        weight REAL,
        date TEXT
      )
    ''');
  }

  Future<void> insertWorkout(Workout workout) async {
    final db = await instance.database;
    await db.insert('workouts', workout.toMap());
  }

  Future<List<Workout>> getAllWorkouts() async {
    final db = await instance.database;
    final result = await db.query('workouts');
    return result.map((map) => Workout.fromMap(map)).toList();
  }

  Future<void> deleteWorkout(String id) async {
    final db = await instance.database;
    await db.delete('workouts', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
