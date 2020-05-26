import 'package:intl/intl.dart';
import 'package:formgalley/Forms/Base/formExport.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:formgalley/Utilities/util.dart';
import 'dart:async';
import 'package:formgalley/User/data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static Future<List<String>> getFormFromFirebase(FormBase form) async {
    var contentList = List<String>();
    //print('Fetching ${form.id} content with path ${form.contentPath}');
    DocumentReference docRef = Firestore.instance.document(form.contentPath); //This is just a local var storing a reference
    DocumentSnapshot doc = await docRef.get(source: Source.serverAndCache);
    contentList.add(doc.data['content']);

    return contentList;
  }

  static Future<List<Map<String, dynamic>>> getFormDataFromFirebase() async {
    //Pull all the form data from the server if doesn't exist in cache
    //TODO if exists in cache and this method was run within N minutes/hours/days - pull from cache instead to save Google reads
    //print('Fetching form data');

    QuerySnapshot snapshot = await Firestore.instance.collection('forms').getDocuments(source: Source.serverAndCache);

    //print('Form data is from cache: ${snapshot.metadata.isFromCache}');

    List<DocumentSnapshot> docs = snapshot.documents;

    var formMap = List<Map<String, dynamic>>();

    for (int i = 0; i < docs.length; i++) {
      var current = docs[i];
      formMap.add(current.data);
    }

    return formMap;
  }

  //--------------------------------------------------------------------------------------//
  //---------------------------------------Local DB---------------------------------------//
  //--------------------------------------------------------------------------------------//
  static Database instance;

  //https://flutter.dev/docs/cookbook/persistence/sqlite
  //Gets the database. If the tables don't exist, create them.
  //This should be called when the application starts
  static Future<void> initializeLocalDb() async {
    var path = join(await getDatabasesPath(), 'formgalley.db');
    instance = await openDatabase(
      path,
      onCreate: (db, version) async {
        await db
            .execute("CREATE TABLE completedForms(id TEXT PRIMARY KEY, formName TEXT, longName TEXT, date TEXT, path TEXT)");
        await db.execute("CREATE TABLE userData(id INTEGER PRIMARY KEY, value TEXT)");
      },
      version: 1,
    );
  }

  static Future<void> saveUserData(List<Data> dataObjects) async {
    dataObjects.forEach((data) async {
      if (data.tempId == 'notTempData') {
        //This DOES store empty values as ''
        await instance.insert(
          'userData',
          data.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  static Future<List<Map<String, dynamic>>> getUserDataFromLocalDb() async {
    final List<Map<String, dynamic>> maps = await instance.query('userData');
    return maps;
  }

  static Future<void> saveFormDataLocalDb(FormBase form, String path) async {
    //formName TEXT PRIMARY KEY, longName TEXT, date TEXT, path TEXT

    var date = DateFormat.yMMMd().format(DateTime.now()).toString();
    await instance.query('completedForms');
    var dateFormat = DateFormat('yyyyMMddHHmmss');
    var id = dateFormat.format(DateTime.now()).toString();

    await instance.insert(
      'completedForms',
      {
        'id': id,
        'formName': form.id, //make a getter
        'longName': form.getLongName(),
        'date': date,
        'path': path,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getSavedFormsData() async {
    List<Map<String, dynamic>> maps = await instance.query('completedForms');
    //print('Retrieved form data from local database');
    return maps;
  }

  static Future<String> debugPrintDatabase() async {
    final List<Map<String, dynamic>> userData = await instance.query('userData');
    var numNotEmpty = 0;
    userData.forEach((f) => f['value'] != '' ? numNotEmpty++ : numNotEmpty);
    var dataPercent = Util.getPercent(numNotEmpty, userData.length);
    String out = '$numNotEmpty of ${userData.length} of user data points have values ($dataPercent%)';
    List<Map<String, dynamic>> forms = await instance.query('completedForms');
    out += '\n${forms.length} completed forms exist in database';
    print(out);
    return out;
  }

  static Future<bool> deleteFromTable(String table, String id) async {
    var statement = 'DELETE FROM $table WHERE id = $id';
    try {
      await instance.execute(statement);
      print('Deleted $id from $table table');
      return true;
    } catch (err) {
      print('Failed to delete item $id from the database');
      return false;
    }
  }
}
