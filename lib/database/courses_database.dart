import 'dart:async';
import 'package:path/path.dart';
import 'package:skursbiachle/model/courses.dart';
import 'package:sqflite/sqflite.dart';

import '../model/teacher.dart';


class CoursesDatabase {

  static final CoursesDatabase instance = CoursesDatabase._init();
  static Database? _database;

  CoursesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('courses.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE courses(id INTEGER PRIMARY KEY, '
        'gName TEXT NOT NULL, '
        'groupId TEXT NOT NULL, '
        'courseId TEXT NOT NULL, '
        'colorCode TEXT NOT NULL, '
        'amPm TEXT NOT NULL, '
        'startTime TEXT NOT NULL, '
        'courseDate TEXT NOT NULL, '
        'amountPupils TEXT NOT NULL'
        ')');
  }

  Future<CourseDB> create(CourseDB course) async {
    final db = await instance.database;

    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    final id = await db.insert(tableCourses, course.toMap());
    return course.copy(id: id);
  }

  Future<CourseDB> readKey(int id) async {
    final db = await instance.database;
    var maps = await db.rawQuery("SELECT * FROM courses");

    if (maps.isNotEmpty) {
      return CourseDB.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableCourses,
      where: '${KeysFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

