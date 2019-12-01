import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:job_adventure/Screens/QuestPage.dart';
import 'package:job_adventure/Widgets/ItemList.dart';
import 'package:job_adventure/Widgets/QuestListReduced.dart';
import 'package:job_adventure/models/user.dart';

//This class is responsable for making the topbar (infowdget)
//interractable
class IntereactableWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    return new GestureDetector(
      child: new InfoWidget(),
      onTap: () {
        Navigator.pushNamed(context, 'profilescreen', arguments: user);
      },
    );
  }
}

//Class of the top widget
class InfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    return new Padding(
        //Padding for the top bar
        padding: EdgeInsets.all(10),
        child: Container(
            //Container to crate the borders of the top bar
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black26, width: 3.0)),
            child: Row(
              //Row for the top bar (status, profile picture, etc)
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(255, 211, 109, 0.4),
                            width: 5.0)),
                    child: Image.asset("assets/images/sprite.png",
                        height: 80,
                        width: 80) //Profile picture, load from DB later
                    ),
                Padding(
                    // Padding for the column whit information, so it don't touch the profile picture
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                        // Column beside the picture, decide later what will be on it
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(user.name, style: TextStyle(fontSize: 20)),
                          Text("Lvl: " + user.level.toString(),style: TextStyle(fontSize: 13)),
                          Text("xp: " + user.xp.toString(), style: TextStyle(fontSize: 13))
                        ]))
              ],
            )));
  }
}

class MainMenu extends StatelessWidget {
  final List<String> taskSamples = <String>[
    "This is a task",
    "This is another task",
    "This is another task"
  ];
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: Column(//Main column
            children: [
      Row(
        children: <Widget>[
          Container(
            height: 20,
          )
        ],
      ),
      
      //This Container creates a iterractable widget from
      //the top bar (infowidget class)
      Container(
        child: new IntereactableWidget()
      ),
      Expanded(
        child: QuestListReduced()
      )
    ]));
  }
}