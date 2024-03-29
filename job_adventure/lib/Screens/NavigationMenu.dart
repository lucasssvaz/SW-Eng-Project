import 'package:flutter/material.dart';
import 'package:job_adventure/Screens/MainMenu.dart';
import 'package:job_adventure/Screens/QuestPage.dart';
import 'package:job_adventure/Screens/comingsoonpage.dart';
import 'package:job_adventure/Widgets/GuildList.dart';
import 'package:job_adventure/Widgets/GuildMemberList.dart';
import 'package:job_adventure/Screens/GuildPage.dart';
import 'package:job_adventure/Screens/SettingsPage.dart';
import 'package:job_adventure/models/user.dart';

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
    //ProfileScreen(),
    GuildPage(),
    SettingsPage()
  ];
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
      )
    );
  }
}

