import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:formgalley/Widgets/widgetExporter.dart';
import 'package:formgalley/dataEngine.dart';
import 'package:formgalley/db.dart';
import 'package:formgalley/User/data.dart';
import 'package:formgalley/User/user.dart';
import 'package:formgalley/Forms/Base/formExport.dart';
import 'package:formgalley/dialogManager.dart';

//Displays the prompts when getting information from the user needed for the form creation
class CollectionView extends StatefulWidget {
  final FormBase selForm;
  final Function(FormBase) onStartProcessing;

  CollectionView({this.selForm, this.onStartProcessing});

  @override
  _CollectionViewState createState() => new _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  FormBase formToBuild;
  List<Data> dataObjects;
  bool buildingForm = false;
  String pageName = 'My Info';
  String previousPage = 'Create';
  List<String> changedData = List<String>();
  final ValueNotifier<List<Data>> changedDataObjects = ValueNotifier<List<Data>>(List<Data>());

  @override
  void initState() {
    super.initState();
    initialize();
  }

  //Made as separate function to refresh view after save data.
  void initialize() {
    if (widget.selForm == null) {
      //set everything here for being in the data screen
      previousPage = 'Options';
      dataObjects = new List.from(User.instance.userData);
    } else {
      //set everything here for being in the collection screen
      formToBuild = widget.selForm;
      dataObjects = List.from(DataEngine.getDataObjects(formToBuild));
      buildingForm = true;
      pageName = formToBuild.formName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DataTile> dataTiles = buildDataTiles();

    return WillPopScope(
      onWillPop: () async => onPop(),
      child: CupertinoPageScaffold(
        child: CupertinoScrollbar(
          child: CustomScrollView(
            cacheExtent: 50000,
            //Init all tiles - stop overwrite DB with null. Stops unnecessary build. Do make bigger later
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                backgroundColor: Colors.white,
                largeTitle: Text(pageName),
                border: Border(),
                leading: CupertinoButton(
                    padding: EdgeInsets.all(0),
                    child: buildingForm ? Text('Cancel') : Text('Done'),
                    onPressed: () async {
                      bool b = await onPop();
                      if (b ?? false) Navigator.pop(context);
                    }),
                trailing: ValueListenableBuilder(
                    valueListenable: changedDataObjects,
                    builder: (BuildContext context, List<Data> changedData, child) {
                      int i = changedData.length;
                      print('$i item(s) pending changes ${i > 0 ? '(${changedData.last.title})' : ''}');

                      return CupertinoButton(
                        padding: EdgeInsets.all(0),
                        child: widget.selForm == null ? changedData.length > 0 ? Text('Save') : Text('') : Text('Next'),
                        onPressed: () async {
                          if (changedDataObjects.value.length > 0 || buildingForm) {
                            var connectivityResult = await Connectivity().checkConnectivity();
                            if (connectivityResult != ConnectivityResult.none) {
                              await processInput(dataTiles);
                              dataTiles.forEach((tile) => tile.updateTileChangedStatus());
                            } else {
                              await DialogManager.alertUserNoConnection(context);
                            }
                          }
                        },
                      );
                    }),
              ),
              SliverList(
                delegate: SliverChildListDelegate(dataTiles),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DataTile> buildDataTiles() {
    var items = List<DataTile>();
    dataObjects.forEach((data) {
      items.add(DataTile(
        data: data,
        changedDataNotifier: changedDataObjects,
      ));
    });
    return items;
  }

  Future<void> processInput(List<DataTile> dataTiles) async {
    //Run the save data methods here
    await DataEngine.applyInputToDataObjects(dataTiles, dataObjects);
    await DataEngine.applyNewDataToUserData(dataObjects);
    await DB.saveUserData(dataObjects);
    print('Saved data');

    if (buildingForm) {
      formToBuild = await DataEngine.applyInputToFormDataFields(formToBuild, dataObjects);
      widget.onStartProcessing(formToBuild);
    } else {
      initialize();
    }
  }

  Future<bool> onPop() async {
    bool didChange = changedDataObjects.value.length > 0;
    bool doClose = true;
    if (didChange) doClose = await DialogManager.confirmCloseCollectionView(context);
    return doClose;
  }
}
