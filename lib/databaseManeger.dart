import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:firesigneler/modules/Fire.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManeger {
  static  Database? _database ;



  Future<Database?> get database async {
    if (_database == null) {
      _database = await initDB();

    }
    return _database!;
  }
  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
     //var databasesPath ="https://192.168.1.111/Users/rezki/Desktop/database";
    String path = [databasesPath,"//", "database.db"].join();
    Database database = await openDatabase(path, version: 1,
        onCreate: _onCreate
        );

    return database;

  }
Future<void> _onCreate(Database database, int version) async {
  final db = database;
  await db.execute(""" 
   CREATE TABLE IF NOT EXISTS "Fires"(
   fireId INTEGER PRIMARY KEY NOT NULL,
   locationLat Double,
   locationLong Double,
   audio Text,
   image blob
   );
   """);



}
Future <List<Fire>> getFires()async{
  var databasesPath = await getDatabasesPath();

  await database;

    List<Map<String , Object?>>? results = await _database?.rawQuery("Select * from Fires ");
    if(results==null ) return [];
    List<Fire> fires=[];
    results.forEach((element) {fires.add(Fire.fromMap(element));});
    return fires ;
}

  Future <void> addFire(Fire fire)async{
    await database;

     await _database?.rawInsert("Insert Into  Fires (locationLat , locationLong , audio , image) values ( ?, ? , ?, ?) " , [fire.latitude , fire.longitude , fire.audiobits , fire.image]);
  }



  }