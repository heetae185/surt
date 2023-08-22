import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:surt/provider/participants.dart';

class DBHelper {
  Future<Database> _openDb() async {
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, 'surt_database.db');

    final db = await openDatabase(
      path,
      version: 1,
      onConfigure: (Database db) => {},
      onCreate: _onCreate,
      onUpgrade: (Database db, int oldVersion, int newVersion) => {},
    );

    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS surt (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        born_year INT NOT NULL,
        driving_experience INT NOT NULL,
        count INT
      )
    ''');
  }

  Future<void> insert(Participants participants) async {
    final db = await _openDb();
    await db.insert(
      'surt',
      participants.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(String id) async {
    final db = await _openDb();
    await db.delete(
      'surt',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Participants>> getAllParticipants() async {
    List<Participants> participantsList = [];
    final db = await _openDb();
    final List<Map<String, dynamic>> maps = await db.query('surt');
    for (var map in maps) {
      participantsList.add(Participants.fromMap(map));
    }
    return participantsList;
  }
}
