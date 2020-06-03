import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formgalley/Forms/Base/formExport.dart';
import 'package:formgalley/User/data.dart';
import 'package:formgalley/User/user.dart';
import 'package:formgalley/Utilities/util.dart';
import 'package:us_states/us_states.dart';

class DD2558 extends FormBase {
  //This class uses many attributes and methods from the parent class
  //Be sure to call the constructor here to run super constructor

  DD2558() {
    formName = 'DD 2558';
    longName = 'Authorization to Start, Stop or Change an Allotment'; //Redundant-either remove from FireStore or here
    contentPath = '/forms/dd2558/html/content';
  }

  @override
  void generateTempDataRequirements() {
    tempData['effectiveDate'] = Data(
      hintText: DateTime.now(),
      title: 'Effective date',
      prompt: 'The effective date of this allotment.',
      inputMethod: InputMethod.date,
      textInputType: TextInputType.datetime,
      usedInForms: ['DD 2558'],
    );

    tempData['allotmentAmount'] = Data(
      hintText: '99.99',
      title: 'Allotment amount',
      minRequiredChars: 5,
      prompt: 'The amount of the allotment. Use precise commas and decimals.',
      usedInForms: ['DD 2558'],
      inputMethod: InputMethod.currency,
      inputFormatters: [
        LengthLimitingTextInputFormatter(30),
        WhitelistingTextInputFormatter(RegExp(r'^[0-9\.\,]*$')),
      ],
      textInputType: TextInputType.number,
    );

    tempData['allotteeFirst'] = Data(
      hintText: 'William',
      title: 'Allottee\'s first name',
      minRequiredChars: 2,
      prompt: 'The allottee\'s first name.',
      usedInForms: ['DD 2558'],
      inputFormatters: [
        LengthLimitingTextInputFormatter(35),
        WhitelistingTextInputFormatter(RegExp(r"[A-z. '-]")),
      ],
    );
    tempData['allotteeMiddle'] = Data(
      hintText: 'M',
      title: 'Allottee\'s middle initial',
      prompt: 'The allottee\'s middle initial. Leave blank if none.',
      usedInForms: ['DD 2558'],
      inputFormatters: [
        LengthLimitingTextInputFormatter(1),
        WhitelistingTextInputFormatter(RegExp(r'^[A-z]*$')),
      ],
    );
    tempData['allotteeLast'] = Data(
      hintText: 'Smith',
      title: 'Allottee\'s last name',
      minRequiredChars: 2,
      prompt: 'The allottee\'s last name.',
      usedInForms: ['DD 2558'],
      inputFormatters: [
        LengthLimitingTextInputFormatter(35),
        WhitelistingTextInputFormatter(RegExp(r"[A-z. '-]")),
      ],
    );
    tempData['allotmentAction'] = Data(
      //Make sure to always select an actual value for default
      value: null,
      hintText: 'Start',
      title: 'Allotment Action',
      prompt: 'Whether this starts, stops or changes an allotment.',
      usedInForms: ['DD 2558'],
      inputMethod: InputMethod.dropdown,
      dropdownOptions: [
        'Start',
        'Stop',
        'Change',
      ],
    );
    tempData['termInMonths'] = Data(
      hintText: '12',
      title: 'Term in Months',
      prompt: 'The duration of the allotment in months.',
      usedInForms: ['DD 2558'],
      textInputType: TextInputType.number,
    );
    tempData['creditLine'] = Data(
      hintText: 'A23DF352S4V',
      title: 'Credit Line (if applicable)',
      prompt: 'The line of credit to use.',
      usedInForms: ['DD 2558'],
    );
    tempData['allotmentClass'] = Data(
      //Make sure to set the initial value as null to allow hint text
      //Drop downs should not have hint text
      value: null,
      title: 'Allotment Class Authorized',
      prompt: 'The class of the allotment.',
      usedInForms: ['DD 2558'],
      inputMethod: InputMethod.dropdown,
      dropdownOptions: [
        'C - Charity/CFC',
        'D - Discretionary Allotments',
        'F - Charity - Emergency/Assistance Fund Contribution',
        'L - Repayment of Loan to Service Organization',
        'N - NSLI or USGLI Insurance Premium',
        'T - Payment of Debts to U.S., Delinquent State or Local Income/Employment Taxes',
        '  - Other (Specify)',
      ],
    );
    tempData['otherSpecify'] = Data(
      hintText: 'Specify the other allotment here',
      title: 'Allotment Class Specified',
      prompt: 'If you entered \'Other\' in Allotment Class Authorized, specify what class here, otherwise leave blank.',
      usedInForms: ['DD 2558'],
    );
    tempData['allotteeStreetAddress'] = Data(
      hintText: '123 Pine St',
      title: 'Allottee\'s Street Address/Box Number',
      minRequiredChars: 6,
      prompt: 'The street address or box number where the allottee receives mail.',
      usedInForms: ['DD 2558'],
    );
    tempData['allotteeCity'] = Data(
      hintText: 'Los Angeles',
      title: 'Allottee\'s City',
      minRequiredChars: 2,
      prompt: 'The city where the allottee receives mail.',
      usedInForms: ['DD 2558'],
    );
    tempData['allotteeState'] = Data(
      //Make sure to set the initial value as null to allow hint text
      //Drop downs should not have hint text
      value: null,
      title: 'Allottee\'s State',
      prompt: 'The state where the allottee receives mail.',
      usedInForms: ['DD 2558'],
      inputMethod: InputMethod.dropdown,
      dropdownOptions: USStates.getAllAbbreviations(),
    );
    tempData['allotteeZip'] = Data(
      hintText: '123456',
      title: 'Allottee\'s ZIP Code',
      minRequiredChars: 5,
      prompt: 'The ZIP code where the allottee receives mail.',
      usedInForms: ['DD 2558'],
      textInputType: TextInputType.number,
    );
    tempData['allotteeCountry'] = Data(
      hintText: 'Limousin, France',
      title: 'Allottee\'s Foreign Province and Country',
      minRequiredChars: 2,
      prompt: 'The allottee\'s foreign residence (Province, Country). You can usually leave this blank.',
      usedInForms: ['DD 2558'],
    );
    tempData['remarks'] = Data(
      hintText: 'Here are some remarks.',
      title: 'Remarks',
      prompt: 'Any other remarks you would like entered on this form.',
      usedInForms: ['DD 2558'],
    );
    tempData['companyCode'] = Data(
      hintText: '123456789',
      title: 'Company Code/Financial Institution/Routing Transit Number',
      prompt: 'Your bank\'s routing number. A nine-digit number usually found on the bottom of your check.',
      usedInForms: ['DD 2558'],
    );
    tempData['accountNumber'] = Data(
      hintText: '000011112222',
      title: 'Account Number/Policy Number',
      prompt: 'The accounting number to pull allotment from.',
      usedInForms: ['DD 2558'],
      textInputType: TextInputType.number,
    );
    tempData['accountType'] = Data(
      //Make sure to set the initial value as null to allow hint text
      //Drop downs should not have hint text
      value: null,
      title: 'Account Type',
      prompt: 'Is this account a checking or savings?',
      usedInForms: ['DD 2558'],
      inputMethod: InputMethod.dropdown,
      dropdownOptions: [
        'Checking',
        'Savings',
      ],
    );
    tempData['classLAmount'] = Data(
      hintText: '\$100.00',
      title: 'Total Class L Amount',
      minRequiredChars: 5,
      prompt: 'Class L allotments are used to repay loans to service organizations like Red Cross and Relief Society',
      usedInForms: ['DD 2558'],
      textInputType: TextInputType.number,
    );
    tempData['classTAmount'] = Data(
      hintText: '\$100.00',
      title: 'Total Class T Amount',
      minRequiredChars: 5,
      prompt: 'Class T allotments are used to repay debts to U.S., or other delinquent state or local taxes.',
      usedInForms: ['DD 2558'],
      textInputType: TextInputType.number,
    );
    tempData['signatureDate'] = Data(
      hintText: '12/12/2020',
      title: 'Signature Date',
      prompt: 'The date you signed this form.',
      usedInForms: ['DD 2558'],
      inputMethod: InputMethod.date,
      textInputType: TextInputType.number,
    );

    //Assign the tempId a value for reassigning to the map
    //when the data return from processing
    tempData.forEach((k, v) => v.tempId = k); //this is very important for matching the data back up
  }

  @override
  Future<String> buildForm(String html) async {
    var letters = ['a', 'b', 'c', 'd'];

    for (var letter in letters) {
      for (int i = 0; i < 10; i++) {
        var current = letter + i.toString();
        fill[current] ?? print('$current is null: ${fill[current] == null}');
        html = html.replaceAll('\$$current', fill[current]);
      }
    }
    return html;
  }

  //Here is the logic to get the correct values to the fields
  //which are replace the placeholders in the html
  @override
  Future<void> assignData() async {
    var x = 'X';

    //Dropdown menu-------------
    fill['a0'] = ''; //Air Force
    fill['a1'] = ''; //Army
    fill['a2'] = ''; //Marine Corps
    fill['a3'] = ''; //Navy

    switch (User.instance.branch.getValue()) {
      case 'Air Force':
        fill['a0'] = x;
        break;
      case 'Army':
        fill['a1'] = x;
        break;
      case 'Marine Corps':
        fill['a2'] = x;
        break;
      case 'Navy':
        fill['a3'] = x;
        break;
      default:
      //??
    }
    //End dropdown menu------------

    fill['a4'] = User.instance.lastFirstM; //userLastFirstM
    fill['a5'] = User.instance.dodNum.getValue(); //dodNum
    fill['a6'] = User.instance.milPayGrade.getValue(); //payGrade
    fill['a7'] = User.instance.getAddressLine1; //addressLine1
    fill['a8'] = User.instance.getAddressLine2; //addressLine2
    fill['a9'] = User.instance.personalPhone.getValue(); //personalPhoneNum
    fill['b0'] = tempData['effectiveDate'].getValue(); //effectiveDate
    fill['b1'] = tempData['allotmentAmount'].getValue(); //allotmentAmount

    var allotFirst = tempData['allotteeFirst'].getValue();
    var allotLast = tempData['allotteeLast'].getValue();
    var allotMid = tempData['allotteeMiddle'].getValue();
    fill['b2'] =
        '$allotFirst${Util.conditionalComma(allotLast != '')} $allotMid${Util.conditionalComma(allotMid != '')} $allotLast'; //allotteeFirstMLast

    //Dropdown menu-------------
    fill['b3'] = ''; //isStart
    fill['b4'] = ''; //isStop
    fill['b5'] = ''; //isChange

    switch (tempData['allotmentAction'].getValue()) {
      default:
    }
    //End dropdown menu------------

    fill['b6'] = tempData['termInMonths'].getValue(); //termInMonths
    fill['b7'] = tempData['creditLine'].getValue(); //creditLine

    //Dropdown menu-------------
    fill['b8'] = ''; //isCharityCFC
    fill['b9'] = ''; //isDiscretionary
    fill['c0'] = ''; //isCharityEmergency
    fill['c1'] = ''; //isRepayment
    fill['c2'] = ''; //isNsli
    fill['c3'] = ''; //isUsDebt
    fill['c4'] = ''; //isOther

    switch (tempData['allotmentClass'].getValue()) {
      case 'C - Charity/CFC':
        fill['b8'] = x;
        break;
      case 'D - Discretionary Allotments':
        fill['b9'] = x;
        break;
      case 'F - Charity - Emergency/Assistance Fund Contribution':
        fill['c0'] = x;
        break;
      case 'L - Repayment of Loan to Service Organization':
        fill['c1'] = x;
        break;
      case 'N - NSLI or USGLI Insurance Premium':
        fill['c2'] = x;
        break;
      case 'T - Payment of Debts to U.S., Delinquent State or Local Income/Employment Taxes':
        fill['c3'] = x;
        break;
      case '  - Other (Specify)':
        fill['c4'] = x;
        break;
      default:
    }
    //End dropdown menu------------

    fill['c5'] = tempData['otherSpecify'].getValue(); //otherSpecify
    fill['c6'] = tempData['allotteeStreetAddress'].getValue(); //allotteeAddress1

    var city = tempData['allotteeCity'].getValue();
    var state = tempData['allotteeState'].getValue();
    var zip = tempData['allotteeZip'].getValue();
    var comma;
    (city == '' || state == '') ? comma = '' : comma = ',';
    fill['c7'] = '$city$comma $state $zip'; //allotteeAddress2

    fill['c8'] = ''; //allotteeAddress3 //don't need this one
    fill['c9'] = tempData['allotteeCountry'].getValue(); //foreignAddress
    fill['d0'] = tempData['remarks'].getValue(); //remarks1
    fill['d1'] = ''; //remarks2 //maybe come back to it
    fill['d2'] = tempData['companyCode'].getValue(); //companyCode
    fill['d3'] = tempData['accountNumber'].getValue(); //accountNumber

    //Dropdown menu------------
    fill['d4'] = ''; //isChecking
    fill['d5'] = ''; //isSavings
    switch (tempData['accountType'].getValue()) {
      case 'Checking':
        fill['d4'] = x;
        break;
      case 'Savings':
        fill['d5'] = x;
        break;
      default:
    }
    //End dropdown menu------------

    fill['d6'] = tempData['classLAmount'].getValue(); //classLAmount
    fill['d7'] = tempData['classTAmount'].getValue(); //classTAmount
    fill['d8'] = ''; //signature
    fill['d9'] = ''; //dateYYYYMMDD
  }
}
