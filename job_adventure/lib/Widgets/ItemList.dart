import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class ItemList extends StatelessWidget{
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: Firestore.instance.collection('Users').document('vlademircelsodossantosjunior').collection('Items').snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (!snapshot.hasData) return const Text('Loading...');
//         final int messageCount = snapshot.data.documents.length;
//         return ListView.builder(
//           itemCount: messageCount,
//           itemBuilder: (_, int index) {
//             final DocumentSnapshot document = snapshot.data.documents[index];
//             final dynamic message = document['Name'];
//             return ListTile(
//               title: Text(
//                 message != null ? message.toString() : '<No message retrieved>',
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

void insertItem(String userID, String itemID){
  Firestore.instance.collection('Items').document(itemID).get().then((DocumentSnapshot ds){
    dynamic itemNameMessage = ds['Name'];
    String itemName = itemNameMessage != null? itemNameMessage.toString() : '<No message retrieved>';
    dynamic itemDescriptionMessage = ds['Description'];
    String itemDescription = itemDescriptionMessage != null? itemDescriptionMessage.toString() : '<No message retrieved>';
    dynamic itemLevelMessage = ds['Lvl'];
    String itemLevel = itemNameMessage != null? itemLevelMessage.toString() : '<No message retrieved>';
    dynamic itemPathMessage = ds['ImagePath'];
    String itemPath = itemNameMessage != null? itemPathMessage.toString() : '<No message retrieved>';
    Firestore.instance.collection('Users').document(userID).collection('Items').document(itemID).setData({ 'Name': itemName, 'Description': itemDescription, 'Lvl': int.parse(itemLevel), 'ImagePath': itemPath});
  });
}

class ItemList extends StatelessWidget{
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>( 
      stream: Firestore.instance.collection('Users').document('vlademircelsodossantosjunior').collection('Items').snapshots(), //Replace with user ID
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        final int messageCount = snapshot.data.documents.length;
        return GridView.builder(
          itemCount: messageCount,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (_, int index) {
            final DocumentSnapshot document = snapshot.data.documents[index];
            dynamic message1 = document['Name'];
            String itemName = message1 != null ? message1.toString() : '<No message retrieved>'; 
            dynamic message2 = document['ImagePath'];
            String imagePath = message2 != null ? message2.toString() : '<No message retrieved>';
            return new Card(
              child: new GestureDetector(
                  onTap: () async {await showDialog(
                    context: context,
                    builder: (BuildContext context){
                      dynamic message3 = document['Description'];
                      String itemDescription =  message3 != null ? message3.toString() : '<No message retrieved>';
                      dynamic message4 = document['Lvl'];
                      String itemLevel = message4 != null ? message4.toString() : '<No message retrieved>';
                      return Padding(
                        padding: EdgeInsets.only(bottom: 100.0, top: 100.0),
                        child:Dialog(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    new Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Color.fromRGBO(255, 211, 109, 0.4), width: 5.0)),
                                      padding: const EdgeInsets.all(2.0),
                                      child: new Image.asset(imagePath,height: 80, width: 80),
                                    ),
                                    new Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Column(
                                        children: <Widget>[
                                          Text(itemName,style: TextStyle(fontSize: 20)),
                                          Padding(
                                            padding: EdgeInsets.only(top: 2.0),
                                            child: Text('Lvl $itemLevel',style: TextStyle(fontSize: 15,color:Colors.black.withOpacity(0.6)))
                                          )
                                        ],
                                      )
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15.0,left:8.0,right:3.0),
                                  child: new Text(itemDescription,style: TextStyle(fontSize: 15))
                                )
                              ],
                            )
                          )
                        )
                      );
                    }
                  );},
                  child: new GridTile(
                    child: new Image.asset(imagePath),
                )
              ),
            );
          },
        );
      },
    );
  }
}