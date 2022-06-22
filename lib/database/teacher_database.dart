import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/teacher.dart';


class KeyDatabase {

  static final KeyDatabase instance = KeyDatabase._init();

  static Database? _database;

  KeyDatabase._init();

  Future<Database> get database async {

    if (_database != null) return _database!;



    _database = await _initDB('keys.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE keys(id INTEGER PRIMARY KEY, costumerKey TEXT NOT NULL, costumerSec TEXT NOT NULL, url TEXT NOT NULL)');
  }

  Future<KeyDB> create(KeyDB key) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableTeacher, key.toMap());
    return key.copy(id: id);
  }

  Future<KeyDB> readKey(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTeacher,
      columns: KeysFields.values,
      where: '${KeysFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return KeyDB.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTeacher,
      where: '${KeysFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

