import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:behealthy/Model/calories.dart';
import 'package:behealthy/Model/accounts.dart';
class CaloriesHelper{
  static Database _db;
  final String calTable='YourCalories';
  final String idcol='id';
  final String calcol='calories';
  final String datecol='date';


  Future<Database>get db async{
    if(_db!=null)
      return _db;
    else
      _db=await intDB();
    return _db;
  }

  intDB()async{
    Directory docDirectory= await getApplicationDocumentsDirectory();
    String path=join(docDirectory.path,'Managecalories.db');
    var myOwnDB=await openDatabase(path,version: 1,onCreate: _oncreate);
    return myOwnDB;
  }

  void _oncreate(Database db , int newversion)async {
    var sql = "CREATE TABLE $calTable($idcol INTEGER ,$calcol REAL , $datecol TEXT )";
    await db.execute(sql);
  }

  Future<int>saveSubmission(Calories calories)async {
    var dbClient = await db;
    int result = await dbClient.insert("$calTable", calories.toMap());
    print('saved*********************');
    return result;
  }

  Future<List> getSubmissions(int id)async {
    var sql = "SELECT * FROM $calTable WHERE $idcol = $id";
    var dbclient = await db;
    List result = await dbclient.rawQuery(sql);
    return result.toList();
  }


    Future<int> updateSubmission(Calories cal)async
    {
      var dbclient = await db;
      return await dbclient.update(calTable,cal.toMap(),where:"$idcol=? and $datecol=?",whereArgs: [cal.id,cal.date]);
    }


  Future<int> updateWeight(Account acc)async
  {
    var dbclient = await db;
    return await dbclient.update('accounts',acc.toMap(),where:"$idcol=?",whereArgs: [acc.id]);
  }

  void close() async{
    var dbClient = await  db;
    return await dbClient.close();
  }


  }