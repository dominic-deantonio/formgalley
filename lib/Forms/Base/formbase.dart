import 'package:formgalley/User/data.dart';

class FormBase {
  FormBase() {
    generateTempDataRequirements();
  }

  FormBase.fromMap(Map<String, dynamic> map) {
    print(map);
  }

  //This data does not make sense to keep long term
  Map<String, Data> tempData = {};

  String id; //NO SPACES!!Should be something like DD214 - used to reference the db?
  String longName; //Description of this form
  String content; //The html content that will be used to generate the form
  String contentPath; //The location of the content in the database

  //Creates the temporary data and adds to the tempData list
  void generateTempDataRequirements() {}

  //Override this in the actual forms
  Future<void> assignData() async {}

  Future<String> buildForm(String html) async {
    return '';
  }

  String getLongName() =>
      longName ??
      () {
        print('ABOUT not set for $id');
        return 'ABOUT not set';
      };

  var fill = Map<String, String>();

  List<Data> getDataObjectsAsList() {
    var out = List<Data>();
    tempData.forEach((key, value) => {out.add(value)});
    //print('${out.length} data objects');
    return out;
  }

//These replace the analogs in the content dl'd from db
//Just give these values, and feed them into the HTML content
//  var a0, a1, a2, a3, a4, a5, a6, a7, a8, a9;
//  var b0, b1, b2, b3, b4, b5, b6, b7, b8, b9;
//  var c0, c1, c2, c3, c4, c5, c6, c7, c8, c9;
//  var d0, d1, d2, d3, d4, d5, d6, d7, d8, d9;
}
