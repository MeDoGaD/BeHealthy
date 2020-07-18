import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'accounts.dart';

class AccountsHelper{
static Database _db;
final String accTable='accounts';
final String idcol='id';
final String usercol='username';
final String passcol='password';
final String currcol='current';
final String esticol='estimated';
final String agecol='age';


final String calTable='YourCalories';
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

void _oncreate(Database db , int newversion)async{
var sql="CREATE TABLE $accTable($idcol INTEGER PRIMARY KEY ,$usercol TEXT UNIQUE , $passcol TEXT , $agecol INTEGER , $currcol double NOT NULL , $esticol double NOT NULL)";
await db.execute(sql);
var sql2 = "CREATE TABLE $calTable($idcol INTEGER ,$calcol REAL , $datecol TEXT )";
await db.execute(sql2);
}

Future<int>saveAccount(Account acc)async {
  var dbClient = await db;
  int result = await dbClient.insert("$accTable", acc.toMap());
  return result;
}

Future<int>getCount()async{
  var sql = "SELECT COUNT(*) FROM $accTable";
  var dbclient=await db;
  return Sqflite.firstIntValue(await dbclient.rawQuery(sql));
}

Future<List> getAccounts()async{
var sql = "SELECT * FROM $accTable";
var dbclient=await db;
List result =await dbclient.rawQuery(sql);
return result.toList();
}


void close() async{
  var dbClient = await  db;
  return await dbClient.close();
}

}