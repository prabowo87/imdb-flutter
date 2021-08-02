
import 'dart:async';
//mendukug pemrograman asinkron
import 'dart:io';

import 'package:imdb/models/movie_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'favorite_model.dart';

//bekerja pada file dan directory


//pubspec.yml

//kelass Dbhelper
class DbHelper {
  static DbHelper? _dbHelper;
  static Database? _database;

  DbHelper._createObject();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper??DbHelper._createObject();
  }

  Future<Database> initDb() async {

    //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'omdb.db';

    //create, read databases
    // var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb,onUpgrade:_upgradeDbV3);
    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    //mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase;
  }



  //buat tabel baru dengan nama contact
  void _createDb(Database db, int version) async {

    await db.execute('''
      CREATE TABLE favorite (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imdbID TEXT,
        Title TEXT,
        Year TEXT,
        Poster TEXT,
        Type TEXT
      )
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database??await initDb();
  }



  Future<List<Map<String, dynamic>>> selectMedia(String q) async {
    Database db = await this.database;
    if (q=='') {
      var mapList = await db.query('favorite', orderBy: 'id');
      return mapList;
    }else{
      var mapList = await db.rawQuery("SELECT * FROM `favorite` WHERE imdbID='$q' or Title like '%$q%'");

      return mapList;
    }
  }
  Future<List<Map<String, dynamic>>> selectMediaImdbID(String q) async {
    Database db = await this.database;
    if (q=='') {
      var mapList = await db.query('favorite', orderBy: 'id');
      return mapList;
    }else{
      var mapList = await db.rawQuery("SELECT * FROM `favorite` WHERE imdbID='$q'");

      return mapList;
    }
  }

//create databases

  Future<int> insertMedia(MovieModel movieModel) async {
    var imdbID = movieModel.imdbID;
    var title = movieModel.title;
    var year = movieModel.year;
    var poster = movieModel.poster;
    var type = movieModel.type;
    Database db = await this.database;
    var ab = db.getVersion();
    var mapList = await db.rawQuery("SELECT * FROM `favorite` WHERE imdbID='$imdbID'");
    var count =0;
    if (mapList.length<=0) {
      count = await db.rawInsert(
          "INSERT INTO favorite(imdbID,Title,Year,Poster,Type) values('$imdbID','$title','$year','$poster','$type')");
    }else{
      count = await db.rawDelete("DELETE FROM `favorite` WHERE  imdbID='$imdbID'");
    }
    return count;
  }
//update databases

  Future<int> updateMedia(FavoriteModel object) async {
    Database db = await this.database;
    int count = await db.update('favorite', object.toMap(),
        where: 'id=?',
        whereArgs: [object.id]);
    return count;
  }
  //delete row

  Future<int> deleteRowMedia(FavoriteModel object) async {
    Database db = await this.database;
    var id= object.id;
    int count = await db.rawDelete("DELETE FROM `favorite` WHERE  id='$id'");
    return count;
  }

//delete databases

  Future<int> deleteMedia() async {
    Database db = await this.database;
    int count = await db.delete('favorite');
    return count;
  }

  Future<FavoriteModel?> getFavoriteImdbID(String q) async {
    var contactMapList = await selectMediaImdbID(q);
    int count = contactMapList.length;
    FavoriteModel? contactList ;
    for (int i=0; i<count; i++) {
      contactList=FavoriteModel.fromMap(contactMapList[i]);
    }
    return contactList;
  }
  Future<List<FavoriteModel>> getFavorite(String q) async {
    var contactMapList = await selectMedia(q);
    int count = contactMapList.length;
    List<FavoriteModel> contactList = [];
    for (int i=0; i<count; i++) {
      contactList.add(FavoriteModel.fromMap(contactMapList[i]));
    }
    return contactList;
  }

}