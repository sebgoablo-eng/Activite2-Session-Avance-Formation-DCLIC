import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'endroit.dart';

/// Accès bas niveau à la base SQLite. Pattern Singleton.
class DatabaseService {
  DatabaseService._internal();
  static final DatabaseService instance = DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      p.join(dbPath, 'endroits_favoris.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE endroits (
            id        TEXT PRIMARY KEY,
            nom       TEXT NOT NULL,
            imagePath TEXT NOT NULL,
            latitude  REAL,
            longitude REAL,
            adresse   TEXT,
            dateAjout TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insert(Endroit e) async {
    final db = await database;
    await db.insert(
      'endroits',
      e.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchAll() async {
    final db = await database;
    return db.query('endroits', orderBy: 'dateAjout DESC');
  }

  Future<void> delete(String id) async {
    final db = await database;
    await db.delete('endroits', where: 'id = ?', whereArgs: [id]);
  }
}
