import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:formgalley/Widgets/widgetExporter.dart';
import 'package:formgalley/dataEngine.dart';
import 'package:formgalley/db.dart';
import 'package:formgalley/User/data.dart';
import 'package:formgalley/User/user.dart';
import 'package:formgalley/Forms/Base/formExport.dart';

//Displays the prompts when getting information from the user needed for the form creation
class CollectionView extends StatefulWidget {
  final FormBase selectedForm;
  final Function(FormBase) onStartProcessing;

  CollectionView({this.selectedForm, this.onStartProcessing});

  @override
  _CollectionViewState createState() => new _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  FormBase formToBuild;
  List<Data> dataObjects;
  bool saving = false;
  bool buildingForm = false;
  String pageName = 'My Info';
  String previousPage = 'Create';
  var summary;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  //Made as separate function to refresh view after save data.
  void initialize() {
    if (widget.selectedForm == null) {
      //set everything here for being in the data screen
      previousPage = 'Options';
      dataObjects = new List.from(User.instance.userData);
    } else {
      //set everything here for being in the collection screen
      formToBuild = widget.selectedForm;
      dataObjects = List.from(DataEngine.getDataObjects(formToBuild));
      buildingForm = true;
      pageName = formToBuild.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DataTile> dataTiles = buildDataTiles();

    return CupertinoPageScaffold(
      child: CupertinoScrollbar(
        child: CustomScrollView(
          cacheExtent: 50000,
          //Init all tiles - stop overwrite DB with null. Stops unnecessary build. Do make bigger later
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              backgroundColor: Colors.white,
              largeTitle: Text(pageName),
              previousPageTitle: previousPage,
              border: Border(),
              trailing: CupertinoButton(
                padding: EdgeInsets.all(0),
                child: widget.selectedForm == null ? Text('Save') : Text('Next'),
                onPressed: () async {
                  await processInput(dataTiles);
                  dataTiles.forEach((tile) => tile.updateTileColor());
                },
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                dataTiles,
              ),
            )
          ],
        ),
      ),
    );
  }

  List<DataTile> buildDataTiles() {
    var items = List<DataTile>();
    dataObjects.forEach((data) => items.add(DataTile(data: data)));
    return items;
  }

  Future<void> processInput(List<DataTile> dataTiles) async {
    if (saving == false) {
      //setState(() => saving = true);

      //Run the save data methods here
      await DataEngine.applyInputToDataObjects(dataTiles, dataObjects);
      await DataEngine.applyNewDataToUserData(dataObjects);
      await DB.saveUserData(dataObjects);
      print('Saved data');

      if (buildingForm) {
        formToBuild = await DataEngine.applyInputToFormDataFields(formToBuild, dataObjects);
        widget.onStartProcessing(formToBuild);
      } else {
        print('Saved Values - TODO alert user');
        initialize();
      }

      //setState(() => saving = false);
    }
  }
}
