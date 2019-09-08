import 'package:flutter/material.dart';
import 'package:job_adventure/Screens/MainMenu.dart';
import 'package:job_adventure/Screens/QuestPage.dart';

class NavigationMenu extends StatefulWidget {
  NavigationMenu({Key key}) : super(key: key);
  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptins = <Widget>[
    MainMenu(),
    QuestPage(),
    Text(
        'Index 2: Guild',
        style: optionStyle
    ),
    Text(
        'Index 3: Settings',
        style: optionStyle
    )
  ];
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptins.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            title: Text('Quest'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text('Guild'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

