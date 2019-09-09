import 'package:flutter/material.dart';
import 'package:job_adventure/Screens/NavigationMenu.dart';
import 'package:job_adventure/Screens/LoginScreen.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
const String URL = "https://trello.com/1/authorize?expiration=never&name=Job+Adventure&scope=read%2Cwrite&response_type=token&key=57a893b02ea2046b82ac861766a34bed";


void main() => runApp(MaterialApp(
  title: 'Job Adventure',
  initialRoute: 'loginScreen',
  routes:{
    'loginScreen': (context) => LoginScreen(),
    'MainMenu': (context) => NavigationMenu(),
    "/webview": (_) => WebviewScaffold(
      url: URL,
      appBar: AppBar(
        title: Text("Login with Trello"),
      ),
      withJavascript: true,
      withLocalStorage: true,
      withZoom: true,
    )
  },
));




