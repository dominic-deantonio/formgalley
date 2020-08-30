import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formgalley/Views/viewsExporter.dart';
import 'package:formgalley/Widgets/widgetExporter.dart';
import 'package:formgalley/db.dart';
import 'package:formgalley/dialogManager.dart';
import 'package:formgalley/options.dart';
import 'Forms/Base/completedForm.dart';
import 'package:formgalley/log.dart';

void main() => runApp(Main());

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  CupertinoThemeData theme;

  @override
  void initState() {
    super.initState();
    updateTheme(Options.instance.getCurrentTheme());
  }

  void updateTheme(CupertinoThemeData opposite) {
    setState(() {
      theme = opposite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      home: Home(updateTheme: (opposite) => updateTheme(opposite)),
      theme: theme,
    );
  }
}

class Home extends StatefulWidget {
  final Function(CupertinoThemeData) updateTheme;

  Home({this.updateTheme});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool didInit = false;
  Exception initException;

  final tabController = CupertinoTabController(initialIndex: 1);
  List<CompletedForm> completedForms;

  @override
  void initState() {
    super.initState();
  }

  void updateFilesTab() async {
    var temp = await DB.getSavedFormsData();
    setState(() => completedForms = temp);
  }

  @override
  Widget build(BuildContext context) {
    Future<Widget> goTo(Widget view) async {
      return await Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext context) => view));
    }

    Future<Widget> goToFullScreen(Widget view) async {
      return await Navigator.of(context, rootNavigator: true)
          .push(CupertinoPageRoute(fullscreenDialog: true, builder: (BuildContext context) => view));
    }

    Future<Widget> goToFullScreenReplacement(Widget view) async {
      return await Navigator.of(context, rootNavigator: true)
          .pushReplacement(CupertinoPageRoute(fullscreenDialog: true, builder: (BuildContext context) => view));
    }

    Future<void> sendFeedback() async {
      DialogManager.sendFeedback(context);
    }

    Future<void> openOptions() async {
      DialogManager.openOptions(
        context: context,
        updateTheme: (opposite) => widget.updateTheme(opposite),
      );
    }

    if (!didInit) {
      return SplashView(
        onSuccessfulLoad: () async => setState(() {
          didInit = true;
          updateFilesTab();
        }),
        onException: (e, s) => goToFullScreenReplacement(ErrorView(e, s)),
      );
    } else {
      return CupertinoTabScaffold(
        controller: tabController,
        tabBar: CupertinoTabBar(
          items: BottomNavBar.items,
          border: Border(),
          onTap: (tab) {
            if (tab == 2) updateFilesTab();
          },
        ),
        tabBuilder: (context, i) {
          return SafeArea(
            child: CupertinoTabView(
              builder: (context) {
                switch (i) {
                  case 0:
                    return PreferencesView(
                      navigateToMyInfo: () async => await goToFullScreen(CollectionView()),
                      openOptionsModal: () async => await openOptions(),
                      giveFeedback: () async => await sendFeedback(),
                      viewLog: () async => await goToFullScreen(LogView()),
                    );
                    break;
                  case 1:
                    return WelcomeView(
                      onException: (e, s) => goToFullScreenReplacement(ErrorView(e, s)),
                      runOnboarding: () => goToFullScreen(OnboardingView()),
                      onFormSelected: (formWithNoInput) async {
                        await goToFullScreen(
                          CollectionView(
                            selForm: formWithNoInput,
                            onStartProcessing: (formWithUserInput) async {
                              await goToFullScreenReplacement(
                                ProcessingView(
                                  onException: (e, s) => goToFullScreenReplacement(ErrorView(e, s)),
                                  formToBuild: (formWithUserInput),
                                  viewPdfCallback: (pdf) async {
                                    await goToFullScreenReplacement(
                                      PdfView(pdf: pdf),
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
                      completedForms: completedForms,
                      openFileCallback: (pdf) => goToFullScreen(PdfView(pdf: pdf)),
                      updateFilesViewCallback: () => updateFilesTab(),
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
}
