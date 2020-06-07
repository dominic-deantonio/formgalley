import 'package:formgalley/encryption.dart';
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
    print('Fetching ${form.formName} content from ${form.contentPath}');
    DocumentReference docRef = Firestore.instance.document(form.contentPath); //Each form knows where its content is
    DocumentSnapshot doc = await docRef.get(source: Source.serverAndCache);
    contentList.add(doc.data['content']);

    return contentList;
  }

  static Future<List<Map<String, dynamic>>> getFormDataFromFirebase() async {
    //Pull all the form data from the server if doesn't exist in cache
    //TODO if exists in cache and this method was run within N minutes/hours/days - pull from cache instead to save Google reads
    //print('Fetching form data');

    QuerySnapshot snapshot = await Firestore.instance.collection('forms').getDocuments(source: Source.serverAndCache);

    print('Form data is from cache: ${snapshot.metadata.isFromCache}');

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
        await db.execute("CREATE TABLE completedForms(id TEXT PRIMARY KEY, formName TEXT, longName TEXT, date TEXT, path TEXT)");
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
          data.prepareForPersistence(), //form as map and encrypt data
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  static Future<List<Map<String, dynamic>>> getUserDataFromLocalDb() async {
    final List<Map<String, dynamic>> maps = await instance.query('userData');
    return maps;
  }

  static Future<CompletedForm> saveFormDataLocalDb(FormBase form, String path) async {
    //formName TEXT PRIMARY KEY, longName TEXT, date TEXT, path TEXT
    var dateFormat = DateFormat('yyyyMMddHHmmss');

    CompletedForm completed = CompletedForm(
      id: dateFormat.format(DateTime.now()).toString(),
      formName: form.formName,
      longName: form.getLongName(),
      dateCompleted: DateFormat.yMMMd().format(DateTime.now()).toString(),
      path: path,
    );

    await instance.query('completedForms');
    await instance.insert(
      'completedForms',
      completed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return completed;
  }

  static Future<List<CompletedForm>> getSavedFormsData() async {
    List<Map<String, dynamic>> maps = await instance.query('completedForms');
    List<CompletedForm> completed = List<CompletedForm>();

    maps.forEach((map) {
      completed.add(CompletedForm(
        id: map['id'],
        formName: map['formName'],
        longName: map['longName'],
        dateCompleted: map['date'],
        path: map['path'],
      ));
    });

    return completed;
  }

  static Future<String> debugPrintDatabase() async {
    List<Map<String, dynamic>> forms = await instance.query('completedForms');
    String out = '${forms.length} completed forms exist in database.';

    final List<Map<String, dynamic>> userData = await instance.query('userData');
    var numNotEmpty = 0;
    userData.forEach((f) => f['value'] != '' ? numNotEmpty++ : numNotEmpty);
    var dataPercent = Util.getPercent(numNotEmpty, userData.length);
    out += '\n$numNotEmpty of ${userData.length} of user data points have values ($dataPercent%)';

    userData.forEach((d) {
      String v = d['value'];
      v = (v == null || v == '') ? v : Encryption.decrypt(v);
      out += '\n${d['id']}: $v';
    });

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
