import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Uso: chamar a classe como GuildMemberList(guildName: --Nome da guilda--)

class GuildMemberList extends StatelessWidget{
  GuildMemberList({Key key,this.guildName}) : super(key:key);
  final String guildName;
  Widget build(BuildContext context){
    return new StreamBuilder(
      stream: Firestore.instance.collection('Guilds').document(guildName).collection('Members').orderBy('memberXP', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (!snapshot.hasData) return const Text('Loading...');
        final int messageCount = snapshot.data.documents.length;
        return ListView.builder(
          itemCount: messageCount,
          itemBuilder: (BuildContext context, int index){
            final DocumentSnapshot document = snapshot.data.documents[index];
            dynamic message1 = document['Name'];
            String userName = message1 != null ? message1.toString() : '<No message retrieved>';
            dynamic message2 = document['memberXP'];
            String xp = message2 != null ? message2.toString() : '<No message retrieved>';
            Color starColor;
            if(index == 0) starColor = Colors.orange[400];
            else if(index == 1) starColor = Colors.grey[400];
            else if(index == 2) starColor = Colors.brown[300];
            else starColor = Colors.blue[500];
            return new Card(
              elevation: 5.0,
              child: 
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      new CircleAvatar(child: new Text((index+1).toString())),
                      new Padding(padding: EdgeInsets.only(right: 10)),
                      new Text(userName),
                      new Spacer(),
                      new Icon(Icons.star,color: starColor),
                      new Text(xp.toString())
                    ],
                  )
                )
              );
          }
        );
      }
    );
  }
}