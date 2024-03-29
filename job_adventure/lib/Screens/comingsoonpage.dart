import 'package:flutter/material.dart';
import 'dart:math';
import 'package:job_adventure/models/user.dart';

import 'package:job_adventure/Screens/TrelloTeamToGuild.dart';
import 'package:job_adventure/models/TrelloOrganization.dart';
import 'package:job_adventure/Screens/TrelloTeams.dart';

var random = Random.secure();
var value = random.nextInt(10);

class ComingSoonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    organizationTrello organization = new organizationTrello("5da4c6252f69cd5be06ce1d9", user);


    //Uso das rodas para listas os Team do trello e criar Quests e Guildas por meio deles
    /*return GestureDetector(
      child: Text("Test TeamGuild"),
      onTap: (){
        Navigator.pushNamed(
          context,
          TrelloTeams.routeName,
          arguments: user
        );
      },
    );*/


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

                Text('Were writing a world for you ${value.toString()}', textScaleFactor: 1.5, textAlign: TextAlign.center,),
                
                ],
          )
        ),
      )
    );
  }
}