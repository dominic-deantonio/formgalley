import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int) onTapCallback;
  final int viewIndex;
  static var items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      title: Text('Preferences'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.description),
      title: Text('Create'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.folder),
      title: Text('Files'),
    ),
  ];

  BottomNavBar({@required this.onTapCallback, @required this.viewIndex});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('My Info'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description),
          title: Text('Create'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.folder),
          title: Text('Files'),
        ),
      ],
      currentIndex: widget.viewIndex,
      onTap: (i) => widget.onTapCallback(i),
    );
  }
}
