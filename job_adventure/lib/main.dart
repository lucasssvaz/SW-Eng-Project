import 'package:flutter/material.dart';
import 'package:job_adventure/Screens/NavigationMenu.dart';
import 'package:job_adventure/Screens/LoginScreen.dart';
import 'package:job_adventure/Screens/comingsoonpage.dart';

void main() => runApp(MaterialApp(
  title: 'Job Adventure',
  initialRoute: 'loginScreen',
  routes:{
    'loginScreen': (context) => LoginScreen(),
    'MainMenu': (context) => NavigationMenu(),
    'NoWhere': (context) => ComingSoonPage(),
    
  }
));




