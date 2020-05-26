import 'package:formgalley/Forms/Base/formExport.dart';
import 'package:formgalley/User/data.dart';
import 'package:formgalley/User/user.dart';

import 'Widgets/widgetExporter.dart';

class DataEngine {
  //User selected some forms to create, gather the actual forms
  static Future<List<FormBase>> getSelectedFormObjects(List<Map<String, dynamic>> forms) async {
    var formList = List<FormBase>();
    var reg = FormRegistry.instance.registeredForms;

    //Add each form to the return list if it exists in the registry
    //This means don't forget to add forms to both the registry and the database when they are ready
    for (int i = 0; i < forms.length; i++) {
      String formNum = forms[i]['formNum'];
      reg.containsKey(formNum) ? formList.add(reg[formNum]) : print('$formNum not found in registry');
    }

    return formList;
  }

  static Future<FormBase> getSelectedFormObject(Map<String, dynamic> form) async {
    var reg = FormRegistry.instance.registeredForms;
    FormBase out;
    //Add each form to the return list if it exists in the registry
    //This means don't forget to add forms to both the registry and the database when they are ready

    String formNum = form['formNum'];
    reg.containsKey(formNum) ? out = (reg[formNum]) : print('$formNum not found in registry');

    return out;
  }

  //Gets the data requirements from the forms.
  static List<Data> getDataObjects(FormBase form) {
    var dataRequirements = List<Data>();
    dataRequirements.addAll(User.instance.getDataForForm(form.id));
    dataRequirements.addAll(form.tempData.values.toList());
    return dataRequirements;
  }


  static Future<void> applyNewDataToUserData(List<Data> dataObjects) async {
    for (var data in dataObjects) {
      if (data.tempId == 'notTempData')
        User.instance.userData.forEach((entry) => entry.title == data.title ? entry = data : null);
    }
    //User.instance.printAllDataValues();
  }

  /// Applies user input to the data objects in the collection view
  static Future<void> applyInputToDataObjects(List<DataTile> dataTiles, List<Data> dataObjects) async{
    for (int i = 0; i < dataTiles.length; i++){
      DataTile tile = dataTiles[i];
      //Run the values through a sanitizer first right here.
      dataObjects[i].setValue(tile.getUserInput());
    }
  }

  /// Applies data objects from collection view to the FormBase non-persistent data objects.
  static Future<FormBase> applyInputToFormDataFields(FormBase form, List<Data> dataObjects) async {
    var newTempData = Map<String, Data>();
    for (Data data in dataObjects) {
      if (data.tempId != 'notTempData') {
        data.usedInForms.contains(form.id) ? newTempData[data.tempId] = data : print('${data.title} not used in ${form.id}');
      }
    }
    form.tempData = newTempData;
    return form;
  }
}
