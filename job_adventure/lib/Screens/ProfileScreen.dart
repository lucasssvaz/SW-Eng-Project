import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_adventure/Widgets/ItemList.dart';
import 'package:job_adventure/models/user.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  //Id to acess the user document on firebase
  int user_id = 1;

  final List<String> taskSamples = <String>[
    "First task",
    "Second task",
    "Third task"
  ];
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    return new Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          backgroundColor: Color.fromRGBO(255, 211, 109, 0.4),
        ),
        body: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //This row sets the space betwin the profile screen and the appbar
              new Row(
                children: <Widget>[
                  Container(
                    height: 20,
                  )
                ],
              ),

              new Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromRGBO(255, 211, 109, 0.4), width: 5.0)),
                padding: const EdgeInsets.all(2.0),
                child: new Image.asset("assets/images/sprite.png",
                    height: 80, width: 80),
              ),

              //This row sets the space betwin the profile screen and the user name text
              new Row(
                children: <Widget>[Container(height: 10)],
              ),

              new StreamBuilder(
                  stream: Firestore.instance.collection('Users').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Text('Loading Data...');
                    return new Column(children: <Widget>[
                      Text(snapshot.data.documents[user_id]['name'],
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Georgia")),
                      Text('Level: ' + snapshot.data.documents[user_id]['level'].toString(),
                          style: new TextStyle(
                              fontSize: 17.0,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w200,
                              fontFamily: "Roboto")),
                      Text('Xp: ' + snapshot.data.documents[user_id]['xp'].toString(),
                          style: new TextStyle(
                              fontSize: 15.0,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w200,
                              fontFamily: "Roboto"))
                    ]);
                  }),

              new Expanded(child: ItemList())

              // new Expanded(
              //     //List of tasks
              //     child: ListView.separated(
              //         padding: EdgeInsets.all(10),
              //         itemCount: taskSamples.length,
              //         itemBuilder: (BuildContext context, int index) {
              //           //Later change item builder to get the tasks from trello
              //           return Container(
              //               height: 50,
              //               color: Color.fromRGBO(255, 211, 109, 0.4),
              //               child:
              //                   Center(child: Text('${taskSamples[index]}')));
              //         },
              //         separatorBuilder: (BuildContext context, int index) =>
              //             const Divider()))
            ]));
  }
}