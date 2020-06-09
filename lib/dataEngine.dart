import 'package:formgalley/Forms/Base/formExport.dart';
import 'package:formgalley/User/data.dart';
import 'package:formgalley/User/user.dart';
import 'package:formgalley/log.dart';

import 'Widgets/widgetExporter.dart';

class DataEngine {
  static Future<FormBase> getSelectedFormObject(Map<String, dynamic> form) async {
    var reg = FormRegistry.instance.registeredForms;
    FormBase out;
    //Add each form to the return list if it exists in the registry
    //This means don't forget to add forms to both the registry and the database when they are ready

    String formNum = form['formNum'];
    if (reg.containsKey(formNum)) {
      out = reg[formNum];
      await Log.write('Found $formNum in registry.');
    } else {
      print(await Log.write('$formNum not found in registry.'));
    }
    return out;
  }

  //Gets the data requirements from the forms.
  static List<Data> getDataObjects(FormBase form) {
    var dataRequirements = List<Data>();
    dataRequirements.addAll(User.instance.getDataForForm(form.formName));
    dataRequirements.addAll(form.tempData.values.toList());
    Log.write('Providing ${dataRequirements.length} data objects for this form (log is not async).');
    return dataRequirements;
  }

  static Future<void> applyNewDataToUserData(List<Data> dataObjects) async {
    int numPersist = 0;
    for (var data in dataObjects) {
      if (data.tempId == 'notTempData')
        User.instance.userData.forEach((entry) => entry.title == data.title ? entry = data : null);
      numPersist++;
    }
    await Log.write('Sent $numPersist of ${dataObjects.length} data objects to the user object.');
  }

  /// Applies user input to the data objects in the collection view
  static Future<void> applyInputToDataObjects(List<DataTile> dataTiles, List<Data> dataObjects) async {
    for (int i = 0; i < dataTiles.length; i++) {
      DataTile tile = dataTiles[i];
      //Run the values through a sanitizer first right here.
      dataObjects[i].setValue(tile.getUserInput());
    }
  }

  /// Applies data objects from collection view to the FormBase non-persistent data objects (Re-matches the temp data).
  static Future<FormBase> applyInputToFormDataFields(FormBase form, List<Data> dataObjects) async {
    var newTempData = Map<String, Data>();
    for (Data data in dataObjects) {
      if (data.tempId != 'notTempData') {
        data.usedInForms.contains(form.formName)
            ? newTempData[data.tempId] = data
            : print('${data.title} not used in ${form.formName}');
      }
    }
    form.tempData = newTempData;
    await Log.write('matched the temp data for ${form.formName} back to the tempData map');
    return form;
  }
}
