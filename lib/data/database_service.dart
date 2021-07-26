import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'models/models.dart';


class DatabaseService {

  static final DatabaseService _databaseService = DatabaseService._internal();
  late Database database;

  factory DatabaseService() {
    return _databaseService;
  }

  DatabaseService._internal();

  Future<void> setupDB() async {
    WidgetsFlutterBinding.ensureInitialized();
      database = await openDatabase(
        join(await getDatabasesPath(), 'sanctum_database.db'),
        onCreate: (db, version) async {

          await db.execute(
            'CREATE TABLE IF NOT EXISTS releases(title TEXT PRIMARY KEY, type TEXT, releaseDate INTEGER, checkDate INTEGER)'
          );

          await db.execute(
            'CREATE TABLE IF NOT EXISTS rumors(title TEXT PRIMARY KEY, type TEXT, releaseWindow TEXT)'
          );

          await db.execute(
            'CREATE TABLE IF NOT EXISTS todos(title TEXT PRIMARY KEY, type TEXT)'
          );

          await db.execute(
            'CREATE TABLE IF NOT EXISTS ongoingShows(title TEXT PRIMARY KEY)'
          );

          await db.execute(
            'CREATE TABLE IF NOT EXISTS musicReleases(title TEXT PRIMARY KEY, type TEXT, releaseDate INTEGER)'
          );

          return;
        },
        version: 1,
      );
  }

  Future<void> insertRecord(IDBModel record, String table) async {
    final db = database;

    await db.insert(
      table,
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateRecord(IDBModel record, String table) async {
    final db = database;

    await db.update(
      table,
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.title],
    );
  }

  Future<void> deleteRecord(IDBModel record, String table) async {
    final db = database;

    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [record.title],
    );
  }

  Future<List<Release>> getReleases() async {
    final db = database;

    final List<Map<String, dynamic>> maps = await db.query('releases');

    return List.generate(maps.length, (i) {
      return Release(
        title: maps[i]['title'],
        type: maps[i]['type'],
        releaseDate: maps[i]['releaseDate'],
        checkDate: maps[i]['checkDate'],
      );
    });
  }

  Future<List<Rumor>> getRumors() async {
    final db = database;

    final List<Map<String, dynamic>> maps = await db.query('rumors');

    return List.generate(maps.length, (i) {
      return Rumor(
        title: maps[i]['title'],
        type: maps[i]['type'],
        releaseWindow: maps[i]['releaseWindow'],
      );
    });
  }

  Future<List<Todo>> getTodos() async {
    final db = database;

    final List<Map<String, dynamic>> maps = await db.query('todos');

    return List.generate(maps.length, (i) {
      return Todo(
        title: maps[i]['title'],
        type: maps[i]['type'],
      );
    });
  }

  Future<List<OngoingShow>> getOngoingShows() async {
    final db = database;

    final List<Map<String, dynamic>> maps = await db.query('ongoingShows');

    return List.generate(maps.length, (i) {
      return OngoingShow(
        title: maps[i]['title'],
      );
    });
  }
}