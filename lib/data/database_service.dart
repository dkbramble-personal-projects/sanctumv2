import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sanctumv2/data/spoofy_service.dart';
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
          database = db;
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
            'CREATE TABLE IF NOT EXISTS musicReleases(title TEXT PRIMARY KEY, artist TEXT, type TEXT, releaseDate INTEGER)'
          );

          final String response = await rootBundle.loadString('lib/data/init_data.json');
          final data = await json.decode(response);
          await insertInitData(data);

          return;
        },
        version: 1,
      );
  }

  Future<void> insertInitData(Map<String, dynamic> jsonData) async {
    var ongoingRecords = jsonData['ongoing'];
    var releaseRecords = jsonData['releases'];
    var todoRecords = jsonData['todos'];
    var rumorRecords = jsonData['rumors'];

    ongoingRecords.forEach((record) async {
      OngoingShow newRecord = new OngoingShow(title:record['title']);
      await insertRecord(newRecord, "ongoingShows");
    });

    releaseRecords.forEach((record) async {
      Release newRecord = new Release(
        title:record['title'],
        checkDate: record['checkDate'] == "Y" ? 1 : 0,
        releaseDate: record['releaseDate'] ?? -1,
        type: record['type']
      );
      await insertRecord(newRecord, "releases");
    });

    rumorRecords.forEach((record) async {
      Rumor newRecord = new Rumor(
          title:record['title'],
          releaseWindow: record['releaseDate'] ?? "",
          type: record['type']
      );
      await insertRecord(newRecord, "rumors");
    });

    todoRecords.forEach((record) async {
      Todo newRecord = new Todo(
          title:record['title'],
          type: record['type']
      );
      await insertRecord(newRecord, "todos");
    });
  }

  Future<int> insertRecord(IDBModel record, String table) async {
    final db = database;

    print("Inserting Record");
    print(record);

    return await db.insert(
      table,
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateRecord(IDBModel record, String table) async {
    final db = database;

    print("Updating Record");
    print(record);

    int response = await db.update(
      table,
      record.toMap(),
      where: 'title = ?',
      whereArgs: [record.title],
    );

    return response;
  }

  Future<int> deleteRecord(IDBModel record, String table) async {
    final db = database;
    print("Deleting Record");
    print(record);

    return await db.delete(
      table,
      where: 'title = ?',
      whereArgs: [record.title],
    );
  }

  Future<int> deleteAllRecords(String table) async {
    final db = database;
    print("Deleting All Records");

    return await db.rawDelete('DELETE FROM ' + table);
  }

  Future<List<Release>> getReleases() async {
    final db = database;

    final List<Map<String, dynamic>> maps = await db.query('releases');

    int compareTo(Release a, Release b) {
      var releaseDateA = a.releaseDate == -1 ? 100000000000 : a.releaseDate;
      var releaseDateB = b.releaseDate == -1 ? 100000000000 : b.releaseDate;
      var equality = releaseDateA - releaseDateB;
      if ( equality != 0) return equality;


      equality = a.type.compareTo(b.type);
      if ( equality != 0) return equality;

      return a.title.compareTo(b.title);
    }

    var releaseList = List.generate(maps.length, (i) {
      return Release(
        title: maps[i]['title'],
        type: maps[i]['type'],
        releaseDate: maps[i]['releaseDate'],
        checkDate: maps[i]['checkDate'],
      );
    });

    releaseList.sort(compareTo);

    return releaseList;
  }

  Future<List<Release>> getReleasesToCheckDate() async {
    final db = database;

    final List<Map<String, dynamic>> maps = await db.query('releases',
        where: 'checkDate = 1',
    );

    var releaseList = List.generate(maps.length, (i) {
      return Release(
        title: maps[i]['title'],
        type: maps[i]['type'],
        releaseDate: maps[i]['releaseDate'],
        checkDate: maps[i]['checkDate'],
      );
    });

    return releaseList;
  }

  Future<List<MusicRelease>> getMusic() async {
    final db = database;

    final List<Map<String, dynamic>> maps = await db.query('musicReleases');

    var musicList = List.generate(maps.length, (i) {
      return MusicRelease(
        title: maps[i]['title'],
        type: maps[i]['type'],
        releaseDate: maps[i]['releaseDate'],
        artist: maps[i]['artist'],
      );
    });

    musicList.sort((a,b) => SpoofyService.getDayCount(b.releaseDate) - SpoofyService.getDayCount(a.releaseDate));

    return musicList;
  }

  Future<List<Rumor>> getRumors() async {
    final db = database;

    final List<Map<String, dynamic>> maps = await db.query('rumors');

    int compareTo(Rumor a, Rumor b) {
      var equality = a.type.compareTo(b.type);
      if ( equality != 0) return equality;

      return a.title.compareTo(b.title);
    }

    var rumorList = List.generate(maps.length, (i) {
      return Rumor(
        title: maps[i]['title'],
        type: maps[i]['type'],
        releaseWindow: maps[i]['releaseWindow'],
      );
    });

    rumorList.sort(compareTo);

    return rumorList;
  }

  Future<List<Todo>> getTodos() async {
    final db = database;

    final List<Map<String, dynamic>> maps = await db.query('todos');

    int compareTo(Todo a, Todo b) {
      var equality = a.type.compareTo(b.type);
      if ( equality != 0) return equality;

      return a.title.compareTo(b.title);
    }

    var todoList = List.generate(maps.length, (i) {
      return Todo(
        title: maps[i]['title'],
        type: maps[i]['type'],
      );
    });

    todoList.sort(compareTo);

    return todoList;
  }

  Future<List<OngoingShow>> getOngoingShows() async {
    final db = database;

    final List<Map<String, dynamic>> maps = await db.query('ongoingShows');

    var ongoingShowList = List.generate(maps.length, (i) {
      return OngoingShow(
        title: maps[i]['title'],
      );
    });

    ongoingShowList.sort((a,b) => a.title.compareTo(b.title));

    return ongoingShowList;
  }
}