import 'package:flutter/material.dart';
import 'dart:math';
import 'package:job_adventure/models/user.dart';

var random = Random.secure();
var value = random.nextInt(10);

class ComingSoonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    //print('CommingSoon username: '+username);
    return new Scaffold(

        backgroundColor:  Color.fromRGBO(255, 211, 109, 0.4),
        
        body: 
          
          Padding(
          padding: EdgeInsets.all(10),
          child: 
            Center(
            child: 
              Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: 
                <Widget>[

                Text('Coming Soon', textScaleFactor: 3.5, textAlign: TextAlign.center,),

                new Image.asset(
                  'assets/images/L_C_S.png',
                  width: 280.0,
                  height: 280.0,
                ),

                Text('We\'re writing a world for you', textScaleFactor: 1.5, textAlign: TextAlign.center,),
                
                ],
          )
        ),
      )
    );
  }
}