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
        body: ListView(children: [
      Padding(
          // Logo
          padding: EdgeInsets.only(top: 100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png", height: 120, width: 80)
            ], //Provisory logo, change it later
          )),
      Padding(
          // Text name of the app, Job Adventure
          padding: EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/textjobadventure.png",
                height: 50,
                width: 280,
              )
            ],
          )),
      Padding(
          // Login with
          padding: EdgeInsets.only(top: 20, right: 30, left: 30),
          child: Text("Login with: ", textAlign: TextAlign.center)),
      Padding(
          // Login button
          padding: EdgeInsets.only(top: 30, left: 100, right: 100),
          child: RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/webview');
            }, // Goes to the main menu when pressed, change when implementing the DB
            //color: Color.fromRGBO(255, 211, 109, 0.4),
            child: Row(
                // Trello logo
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/trellosymbol.png",
                      height: 50, width: 120)
                ]),
          )),
    ]));
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
