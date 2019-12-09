import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_adventure/Screens/GuildPage.dart';
import 'package:job_adventure/models/user.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';

// Uso: só chamar GuildList()

class GuildList extends StatelessWidget{
  Widget build(BuildContext context){
    final User user = ModalRoute.of(context).settings.arguments;
    return new StreamBuilder(
      stream: Firestore.instance.collection('Users').document(user.userName).collection('Guilds').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (!snapshot.hasData) {
          return Center(
              child: Container(
                color: Color.fromRGBO(255, 211, 109, 0.4),
                child: Center(
                  child: Loading(indicator: BallSpinFadeLoaderIndicator(), size: 50.0),
                ),
              )
          );
        }
        final int messageCount = snapshot.data.documents.length;
        return ListView.builder(
          itemCount: messageCount,
          itemBuilder: (BuildContext context, int index){
            final DocumentSnapshot document = snapshot.data.documents[index];
            dynamic message1 = document['Guild_ID'];
            String guildName = message1 != null ? message1.toString() : '<No message retrieved>';
            dynamic message2 = document['ImagePath'];
            String imagePath = message2 != null ? message2.toString() : '<No message retrieved>';
            return new Card(
              elevation: 5.0,
              child: GestureDetector(
                child: Row(
                  children: <Widget>[
                    new Image.asset(imagePath, width: 50.0,height: 50.0),
                    new Padding(padding: EdgeInsets.only(right: 10)),
                    new Text(guildName),
                  ]
                ),
                onTap: (){
                  // Colocar aqui a chamada da página da guilda
                  Navigator.pushNamed(
                    context,
                    GuildDetails.routeName,
                    arguments: guildName
                  );
                },
              )
            );
          },
        );
      },
    );
  }
}