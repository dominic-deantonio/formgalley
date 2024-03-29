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
      print('Found $formNum in registry.');
    } else {
      print('$formNum not found in registry.');
    }
    return out;
  }

  //Gets the data requirements from the forms.
  static List<Data> getDataObjects(FormBase form) {
    var dataRequirements = List<Data>();
    dataRequirements.addAll(User.instance.getDataForForm(form.formName));
    dataRequirements.addAll(form.tempData.values.toList());
    print('Found ${dataRequirements.length} data objects for ${form.formName}.');
    return dataRequirements;
  }

  static Future<void> applyNewDataToUserData(List<Data> dataObjects) async {
    int numPersist = 0;
    for (var data in dataObjects) {
      if (data.tempId == 'notTempData') {
        User.instance.userData.forEach((entry) => entry.title == data.title ? entry = data : null);
        numPersist++;
      }
    }
    print('Sent $numPersist of ${dataObjects.length} data to the user.');
  }

  /// Applies user input to the data objects in the collection view
  static Future<void> applyInputsToDataObjects(List<DataTile> dataCards, List<Data> dataObjects) async {
    for (int i = 0; i < dataCards.length; i++) {
      DataTile card = dataCards[i];
      //Run the values through a sanitizer first right here.
      dataObjects[i].setValue(card.input.value);
    }
    print('Applied input to data objects.');
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
    print('Matched the temp data for ${form.formName} back to the form');
    return form;
  }
}
