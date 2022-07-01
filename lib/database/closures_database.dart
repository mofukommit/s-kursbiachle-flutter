import 'dart:async';
import 'dart:ffi';
import 'package:path/path.dart';
import 'package:skursbiachle/model/closings.dart';
import 'package:sqflite/sqflite.dart';

import '../model/teacher.dart';


class DailyDatabase {

  static final DailyDatabase instance = DailyDatabase._init();
  static Database? _database;

  DailyDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dailyclosing.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE dailyclosing(id INTEGER PRIMARY KEY, buildId TEXT NOT NULL, courseDate TEXT NOT NULL, gId TEXT NOT NULL)');
  }

  Future<DailyDB> create(DailyDB daily) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableDaily, daily.toMap());
    return daily.copy(id: id);
  }

  Future<DailyDB> readKey(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableDaily,
      columns: DailyFields.values,
      where: '${DailyFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DailyDB.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<bool> getExisting(String gId, String buildId) async {
    final db = await instance.database;

    final maps = await db.query(
      tableDaily,
      columns: DailyFields.values,
      where: '${DailyFields.gId} = ? and ${DailyFields.buildId} = ?',
      whereArgs: [gId, buildId],
    );

    if (maps.isNotEmpty){
      return false;
    }else{
      return true;
    }
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableDaily,
      where: '${DailyFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<DailyDB>> getDaily() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('dailyclosing');

    return List.generate(maps.length, (i) {
      return DailyDB(
          id: maps[i]['id'],
          buildId: maps[i]['buildId'],
        gId: maps[i]['gId'],
        courseDate: DateTime.parse(maps[i]['courseDate'])

      );
    });
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

