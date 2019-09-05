import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: LoginScreen()
));

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding( // Logo
            padding: EdgeInsets.only(top: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset("assets/images/logo.png",height: 120,width: 80)], //Logo provisório, trocar quando tiver o logo pronto
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
              onPressed: () {}, // <= Colocar aqui o código a ser rodado quando apertar login
              color: Color.fromRGBO(255, 211, 109, 0.4),
              child: Text('Login',style: TextStyle(fontSize: 20)),
            )
          ),
          Padding( // Register button
            padding: EdgeInsets.only(top: 10),
            child: GestureDetector(
              onTap: () {}, // Colocar aqui o código a ser rodado quando apertar registrar
              child: Center(child: Text('Don\'t have an account? Sign up')) 
            )
          )
        ]
      )
    ); 
  }
}

