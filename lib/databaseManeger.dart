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
    String path = [databasesPath,"//", "data.db"].join();
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
   locationLong Double
   );
   """);
  await db.rawInsert("""Insert Into Fires (locationLat , locationLong) values (? ,?) , (?,?) , (?,?) ;""",[
    36.751669, 3.469903 , 36.752121, 3.469988 , 36.751520, 3.467131
  ]);


}
Future <List<Map<String, Object?>>?> getCords()async{
    await database;
    List<Map<String , Object?>>? results = await _database?.rawQuery("Select * from Fires ");
    return results ;
}

  Future <void> addFire(double lat , double long)async{
    await database;
     await _database?.rawInsert("Insert Into  Fires (locationLat , locationLong) values ( ?, ?) " , [lat , long]);

  }



  }