import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:html/parser.dart' show parse;
//import 'package:html/dom.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const String ACCEPT = 'https://trello.com/1/token/approve';
const String URL = "https://trello.com/1/authorize?expiration=never&name=Job+Adventure&scope=read%2Cwrite&response_type=token&key=57a893b02ea2046b82ac861766a34bed";
const String API_KEY = "57a893b02ea2046b82ac861766a34bed";
const String API_SECRET = "e69cc4919f2196a1318d23981e2389b7ba8ca7425eb7fb1a9cc85862687c4a9f";

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final webview = FlutterWebviewPlugin();



    return Scaffold(
      body: ListView(
        children: [
          Padding( // Logo
            padding: EdgeInsets.only(top: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset("assets/images/logo.png",height: 120,width: 80)], //Provisory logo, change it later
            )
          ),
          Padding( // Username input
            padding: EdgeInsets.only(top: 20, right: 30, left: 30),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Username'
              )
            )
          ),
          Padding( // Password input
            padding: EdgeInsets.only(top: 10, right: 30, left:30),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Password'
              )
            )
          ),
          Padding( // Login button
            padding: EdgeInsets.only(top: 30, left: 100, right: 100),
            child: RaisedButton(
              color: Color.fromRGBO(255, 211, 109, 0.4),
              child: Text('Login',style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.of(context).pushNamed("/webview");
                _ackAlert(context);
              },
            )
          ),
          Padding( // Register button
            padding: EdgeInsets.only(top: 10),
            child: GestureDetector(
              onTap: () {}, // Function to call when a user must register
              child: Center(child: Text('Don\'t have an account? Sign up')) 
            )
          )
        ]
      )
    );
  }



  void _authorise() async {
    http.Client client = new http.Client();

    http.Response response = await client.post(URL);
    print(response.body);

  }

  Future<void> _ackAlert(BuildContext context) {

    String txt;

    /*if (token != null){
      txt = token.accessToken;
    } else {
      txt = 'NULL';
    }*/

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Token Test'),
          content: Text('Placeholder'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void getKey (FlutterWebviewPlugin webview) {
    webview.getUrl()
    webview.onUrlChanged.listen((String url) {
      if (url == ACCEPT){
        var response = http.get(ACCEPT);
        print(response.body);
      }
    });
  }

}