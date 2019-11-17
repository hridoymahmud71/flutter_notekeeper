//flutter
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

//models
import 'package:flutter_notekeeper/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; //singleton
  static Database _database; // Singleton Database
  DatabaseHelper._createInstance(); //named constructor

  String noteTable_tableName = "note";
  String noteTable_colId = "id";
  String noteTable_colTitle = "title";
  String noteTable_colDescription = "description";
  String noteTable_colPriority = "date";
  String noteTable_colDate = "priority";

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database = null) {
      _database = await initializeDb();
    }
  }

  Future<Database> initializeDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/notes.db';

    var notesDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDb;
  }

  void _createDb(Database db, int ver) async {
    var sql = 'CREATE TABLE $noteTable_tableName'
        '('
        '$noteTable_colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$noteTable_colTitle TEXT, '
        '$noteTable_colDescription TEXT,'
        '$noteTable_colPriority INTEGER,'
        '$noteTable_colDate TEXT'
        ')';
    await db.execute(sql);
  }

  //list
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await _database;
    var result =
        db.query(noteTable_tableName, orderBy: "$noteTable_colPriority");
    return result;
  }

  //insert
  Future<int> insertNote(Note note) async {
    Database db = await _database;
    var result = db.insert(noteTable_tableName, note.toMap());
    return result;
  }

  //update
  Future<int> updateNote(Note note) async {
    Database db = await _database;
    var result = db.update(noteTable_tableName, note.toMap(),
        where: "$noteTable_colId=?", whereArgs: [note.id]);
    return result;
  }

  //delete
  Future<int> deleteNote(Note note) async {
    Database db = await _database;
    var result = db.delete(noteTable_tableName, where: "$noteTable_colId=?", whereArgs: [note.id]);
    return result;
  }

  //item count
  Future<int> getCount(Note note) async {
    Database db = await _database;
    List<Map<String,dynamic>> list = await db.rawQuery("SELECT COUNT(*) FROM $noteTable_tableName");
    var result = Sqflite.firstIntValue(list);
    return result;
  }

  //get

}
