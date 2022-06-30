import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper
{
  static final _dbname='test.db';
  static final _dbversion=1;
  static final _tableName='todo';
  static final columnid='id';
  static final columntask='task';

  static Database? _database;

  DatabaseHelper._privateConstructor();
  static DatabaseHelper instance=DatabaseHelper._privateConstructor();

  Future<Database> get databse async => _database??=await _initDatabase();

  _initDatabase() async{
    Directory documentdirectory=await getApplicationDocumentsDirectory();
    String path=join(documentdirectory.path,_dbname);
    return await openDatabase(path,version: _dbversion,onCreate: _oncreate);
  }

  Future _oncreate(Database db,int version) async{
    await db.execute(
      'CREATE TABLE $_tableName($columnid INTEGER PRIMARY KEY,$columntask TEXT NOT NULL)'
    );
  }

  Future<int> insert(Map<String,dynamic> data) async
  {
      Database db=await instance.databse;
      return await db.insert(_tableName, data);
  }
  
  Future<List<Map<String,dynamic>>> queryAll() async{
    Database db=await instance.databse;
    return await db.query(_tableName);
  }
  
  Future<int> delete(int id) async{
    Database db=await instance.databse;
    return await db.delete(_tableName,where: '$columnid=?',whereArgs: [id]);
  }

}