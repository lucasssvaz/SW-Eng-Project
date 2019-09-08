import 'package:flutter/material.dart';
import 'package:job_adventure/Screens/NavigationMenu.dart';
import 'package:job_adventure/Screens/LoginScreen.dart';

void main() => runApp(MaterialApp(
  title: 'Job Adventure',
  initialRoute: 'loginScreen',
  debugShowCheckedModeBanner: false,
  routes:{
    'loginScreen': (context) => LoginScreen(),
    'MainMenu': (context) => NavigationMenu()
  }
));




