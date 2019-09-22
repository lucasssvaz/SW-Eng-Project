import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
