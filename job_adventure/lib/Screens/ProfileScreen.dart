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
  final List<String> taskSamples = <String>[
    "First task",
    "Second task",
    "Third task"
  ];
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    print("USERNAME"+user.userName);
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
                  //fix the document name to the current user name
                  stream: Firestore.instance
                      .collection('Users')
                      .document(user.userName)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Text('Loading Data...');
                    var userDocument = snapshot.data;
                    return new Column(children: <Widget>[
                      Text(userDocument['name'],
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Georgia")),
                      Text('Level: ' + userDocument['level'].toString(),
                          style: new TextStyle(
                              fontSize: 17.0,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w200,
                              fontFamily: "Roboto")),
                      Text('Xp: ' + userDocument['xp'].toString(),
                          style: new TextStyle(
                              fontSize: 15.0,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w200,
                              fontFamily: "Roboto"))
                    ]);
                  }),

              //Sets a space betwin the item list and the top
              new Row(children: <Widget>[Container(height: 10)]),

              new Expanded(
                  //List of tasks
                  child: ListView.separated(
                padding: EdgeInsets.all(10),
                itemCount: taskSamples.length,
                itemBuilder: (BuildContext context, int index) {
                  //Later change item builder to get the tasks from trello
                  return Container(
                      height: 50,
                      color: Color.fromRGBO(255, 211, 109, 0.4),
                      child: Center(child: Text('${taskSamples[index]}')));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              )),

               //Sets a space betwin the item list and the top
              new Row(children: <Widget>[Container(height: 15)]),

              new Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(255, 211, 109, 0.4),
                          width: 5.0)),
                  padding: const EdgeInsets.all(2.0),
                  child: new Row(children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Item List',
                            style: new TextStyle(
                                fontSize: 16,
                                color: const Color(0xFF000000),
                                fontWeight: FontWeight.w300,
                                fontFamily: "Roboto"))),

                    //Colocar o item list dentro desde container
                    //new Column(children: <Widget>[new Expanded(child: new ItemList(),)],),
                  ])),

              new Expanded(child: ItemList()),

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
