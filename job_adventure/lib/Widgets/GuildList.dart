import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Uso: só chamar GuildList()

class GuildList extends StatelessWidget{
  Widget build(BuildContext context){
    return new StreamBuilder(
      stream: Firestore.instance.collection('Users').document('vlademircelsodossantosjunior').collection('Guilds').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (!snapshot.hasData) return const Text('Loading...');
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
              child: GestureDetector(
                child: ListTile(
                  title: Text(guildName),
                  leading: ImageIcon(new AssetImage(imagePath)),
                ),
                onTap: (){
                  // Colocar aqui a chamada da página da guilda
                },
              )
            );
          },
        );
      },
    );
  }
}