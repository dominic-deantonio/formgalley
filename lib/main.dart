import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/Views/viewsExporter.dart';
import 'package:formgalley/Widgets/widgetExporter.dart';
import 'package:formgalley/db.dart';
import 'package:formgalley/routeManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(Main());

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  var _didInitialize = false;

  @override
  Widget build(BuildContext context) {
    if (_didInitialize)
      return CupertinoApp(
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        home: Home(),
        onGenerateRoute: RouteManager.generateRoute,
      );
    else {
      return CupertinoApp(
        home: SplashScreen(
          onCompletedLoading: () async{
            setState(() {
              _didInitialize = true;
            });
          },
        ),
      );
    }
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final tabController = CupertinoTabController(initialIndex: 1);
  List<Map<String, dynamic>> finishedFormsData;

  void updateFilesTab() async {
    List<Map<String, dynamic>> f = List.from(await DB.getSavedFormsData());
    setState(() => finishedFormsData = f);

  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: tabController,
      tabBar: CupertinoTabBar(
        items: BottomNavBar.items,
        border: Border(),
        backgroundColor: Colors.white,
        onTap: (tab) async {
          if (tab == 2) {
            updateFilesTab();
          }
        },
      ),
      tabBuilder: (context, i) {
        return SafeArea(
          child: CupertinoTabView(
            builder: (context) {
              //------Readability functions
              Future<Widget> goTo(Widget view) async {
                return await Navigator.of(context).push(CupertinoPageRoute(builder: (context) => view));
              }

//https://stackoverflow.com/questions/60349741/what-is-the-use-of-rootnavigator-in-navigator-ofcontext-rootnavigator-true
              Future<Widget> goToFullScreen(Widget view) async {
                return await Navigator.of(context, rootNavigator: true)
                    .push(CupertinoPageRoute(fullscreenDialog: true, builder: (BuildContext context) => view));
              }

              Future<Widget> goToFullScreenReplacement(Widget view) async {
                return await Navigator.of(context, rootNavigator: true)
                    .pushReplacement(CupertinoPageRoute(fullscreenDialog: true, builder: (BuildContext context) => view));
              }
              //------End readability functions

              switch (i) {
                case 0:
                  return MeView(
                    navigateToMyInfo: () async {
                      await goToFullScreen(CollectionView());
                    },
                  );
                  break;
                case 1:
                  return WelcomeView(
                    runOnboarding: (){
                      goToFullScreen(OnboardingView());
                    },
                    onFormSelected: (formWithNoInput) async {
                      await goToFullScreen(
                        CollectionView(
                          selectedForm: formWithNoInput,
                          onStartProcessing: (formWithUserInput) async {
                            await goToFullScreenReplacement(
                              ProcessingView(
                                formToBuild: (formWithUserInput),
                                onViewPdf: (path) async {
                                  await goToFullScreenReplacement(
                                    PdfView(pdfPath: path),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                  break;
                case 2:
                  return FilesView(
                    //Must update this after generating new documents
                    openFileCallback: (path) => goTo(PdfView(pdfPath: path)),
                    updateFilesViewCallback: () => updateFilesTab(),
                    files: finishedFormsData,
                  );
                  break;
                default:
                  return Text('Error. This should be impossible');
              }
            },
          ),
        );
      },
    );
  }
}
