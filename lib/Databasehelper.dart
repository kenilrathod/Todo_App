import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Databasehelper {
  static final _databasename = "todo.db";
  static final _databaseversion = 1;
  static final table = "my_table";
  static final columnid = 'id';
  static final columntask = "task";

  static Database? _database;

  Databasehelper._privateConstructor();
  static final Databasehelper instance = Databasehelper._privateConstructor();

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentdirectory = await getApplicationDocumentsDirectory();
    String path = join(documentdirectory.path, _databasename);
    return await openDatabase(path,
        version: _databaseversion, onCreate: _oncreate);
  }

  Future _oncreate(Database db, int version) async {
    await db.execute(''' 
        CREATE TABLE $table
        (
          $columnid INTEGER PRIMARY KEY,
          $columntask TEXT NOT NULL
        )
        ''');
  }

  Future<int> insertTodo(Map<String, Object?> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> getallTodo() async {
    Database db = await instance.database;
    return db.query(table);
  }

  Future<int> deleteTodo(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnid = ?', whereArgs: [id]);
  }
}
