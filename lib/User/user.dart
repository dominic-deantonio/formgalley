import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formgalley/User/data.dart';
import 'package:formgalley/Utilities/formatters.dart';
import 'package:formgalley/encryption.dart';
import 'package:mock_data/mock_data.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:us_states/us_states.dart';

class User {
  //Create the single instance
  static final User instance = User._privateConstructor();
  var userData = List<Data>(); //Contains all of the data inside the User class

  User._privateConstructor() {
    //These aren't new instances
    userData = [
      firstName,
      middleName,
      lastName,
      birthDate,
      branch,
      dodNum,
      milPayGrade,
      streetAddress,
      addressApartment,
      addressCity,
      addressState,
      addressZip,
      personalPhone
    ];
  }

  //Class methods
  List<Data> getDataForForm(String formId) {
    var out = List<Data>();

    userData.forEach((f) => f.usedInForms.contains(formId) ? out.add(f) : null);

    return out;
  }

  void printAllDataValues() {
    userData.forEach((f) => print(f.getValue()));
  }

  Future<void> loadUserDataToInstance(List<Map<String, dynamic>> maps) async {
    //print('Assigning user data: ');

    for (var map in maps) {
      var key = map['id'];
      var val = map['value']; //these values can be brought in as null - check with encryption
      val = (val == '' || val == null) ? val : Encryption.decrypt(val);
      for (var data in userData) {
        if (data.databaseId == key) {
          data.setValue(val);
          break;
        }
      }
    }
  }

  //Data fields--------------------------------------
  Data firstName = Data(
    databaseId: 101,
    hintText: mockName(),
    title: 'First name',
    prompt: 'Your first name.',
    usedInForms: ['DD 2558'],
    minRequiredChars: 2,
    inputFormatters: Formatters.name,
  );

  Data middleName = Data(
    databaseId: 103,
    hintText: mockName(),
    title: 'Middle name',
    prompt: 'Your middle name. Leave blank if none.',
    usedInForms: ['DD 2558'],
    minRequiredChars: 1,
    inputFormatters: Formatters.name,
  );

  Data lastName = Data(
    databaseId: 102,
    hintText: 'Formson',
    title: 'Last name',
    prompt: 'Your last name.',
    usedInForms: ['DD 2558'],
    minRequiredChars: 2,
    inputFormatters: Formatters.name,
  );

  Data birthDate = Data(
    databaseId: 104,
    hintText: DateTime.now(),
    title: 'Birth date',
    prompt: 'Your date of birth.',
    minRequiredChars: 1,
    inputMethod: InputMethod.date,
    textInputType: TextInputType.datetime,
    usedInForms: ['DD 2558'],
  );

  Data branch = Data(
    databaseId: 105,
    value: null,
    hintText: 'Select...',
    title: 'Service branch',
    prompt: 'Your branch of military.',
    usedInForms: ['DD 2558'],
    minRequiredChars: 1,
    inputMethod: InputMethod.dropdown,
    dropdownOptions: [
      'Air Force',
      'Army',
      'Marine Corps',
      'Navy',
      'Coast Guard',
    ],
  );

  Data dodNum = Data(
    databaseId: 106,
    hintText: '0123456789',
    //ten digits
    title: 'DOD number',
    minRequiredChars: 10,
    usedInForms: ['DD 2558'],
    prompt: 'The unformatted 10-digit number found on the back of your DOD ID (CAC).',
    textInputType: TextInputType.number,
    inputFormatters: Formatters.numeric(10),
  );

  Data milPayGrade = Data(
    databaseId: 107,
    hintText: 'E-1',
    title: 'Pay grade',
    usedInForms: ['DD 2558'],
    minRequiredChars: 3,
    prompt: 'Your pay grade, e.g., E-1, O-5, CWO-2.',
    inputFormatters: Formatters.payGrade,
  );

  Data streetAddress = Data(
    databaseId: 108,
    hintText: '11 Wall St.',
    title: 'Street address',
    prompt: 'Your residential street name and number.',
    minRequiredChars: 6,
    usedInForms: ['DD 2558'],
    inputFormatters: Formatters.streetAddress,
  );

  Data addressApartment = Data(
    databaseId: 109,
    hintText: 'Apt 999',
    title: 'Apartment',
    prompt: 'Your apartment or unit number. Include the prefix \'Unit\' or \'Apt.\'',
    minRequiredChars: 1,
    usedInForms: ['DD 2558'],
    inputFormatters: Formatters.apartment,
  );

  Data addressCity = Data(
    databaseId: 110,
    hintText: 'Washington',
    title: 'City',
    prompt: 'Your city of residence.',
    minRequiredChars: 2,
    usedInForms: ['DD 2558'],
    inputFormatters: Formatters.city,
  );

  Data addressState = Data(
    databaseId: 111,
    value: null,
    hintText: 'NV',
    minRequiredChars: 1,
    title: 'State',
    prompt: 'Your state of residence.',
    usedInForms: ['DD 2558'],
    inputMethod: InputMethod.dropdown,
    dropdownOptions: USStates.getAllAbbreviations(),
  );

  Data addressZip = Data(
    databaseId: 112,
    hintText: '90210',
    title: 'ZIP code',
    minRequiredChars: 5,
    prompt: 'Your 5-digit ZIP code with or without the 4-digit extension.',
    usedInForms: ['DD 2558'],
    textInputType: TextInputType.number,
    inputFormatters: Formatters.zip,
  );

  Data personalPhone = Data(
    databaseId: 113,
    hintText: '1234567890',
    minRequiredChars: 10,
    title: 'Personal phone number',
    prompt: 'Your unformatted 10-digit U.S. phone number.',
    usedInForms: ['DD 2558'],
    textInputType: TextInputType.number,
    inputFormatters: Formatters.phone,
  );

  //Helper methods-----------------------
  String get getAddressLine1 => '${streetAddress.getValue()} ${addressApartment.getValue()}';

  String get getAddressLine2 =>
      '${addressCity.getValue()}${Util.conditionalComma(addressCity.value != null && addressState != null)} ${addressState.getValue()} ${addressZip.getValue()}';

  String get firstLastName => '${firstName.getValue()} ${lastName.getValue()}';

  String get lastFirstM {
    String output = '';
    output += lastName.getValue();
    output += Util.conditionalComma(firstName.getValue() != '' && lastName.getValue() != '');
    output += ' ${firstName.getValue()}';
    output += middleInitial != '' ? ' $middleInitial' : '';
    return output;
  }

  String get middleInitial {
    var out = '';
    if (middleName.getValue().length >= 1) {
      out = middleName.getValue()[0];
    }
    return out;
  }

  int get ageInYears => birthDate.value != null ? (DateTime.now().difference(birthDate.value).inDays / 365).floor() : '';
}
