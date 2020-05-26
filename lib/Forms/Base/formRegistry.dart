import 'package:formgalley/Forms/Base/formExport.dart';

class FormRegistry{

  static final FormRegistry instance = FormRegistry();

  //This should be mapped to what the name is in the database
  final Map<String, FormBase> registeredForms = {
    'DD 2558' : DD2558(),
  };
}