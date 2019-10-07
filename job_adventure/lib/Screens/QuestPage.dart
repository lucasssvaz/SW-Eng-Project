import 'package:loading/indicator/ball_beat_indicator.dart';
import 'package:loading/indicator/ball_grid_pulse_indicator.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/indicator/ball_scale_indicator.dart';
import 'package:loading/indicator/ball_scale_multiple_indicator.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/indicator/line_scale_indicator.dart';
import 'package:loading/indicator/line_scale_party_indicator.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../models/quest.dart';
import 'package:flutter/material.dart';
import 'package:job_adventure/models/user.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class QuestPage extends StatefulWidget {
  @override
  _QuestPageState createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: FutureBuilder(
          future: user.getQuests(),
          builder: (BuildContext context, AsyncSnapshot<List<Quest>> quests){
            if(!quests.hasData){
              return Center(
                child: Container(
                  color: Color.fromRGBO(255, 211, 109, 0.4),
                  child: Center(
                    child: Loading(indicator: BallSpinFadeLoaderIndicator(), size: 50.0),
                  ),
                )
              );
            }
            else{
              final listquests = quests.data;
              print("Tamanho da lista : "+listquests.length.toString());
              return Scaffold(
                  body: ListView.builder(
                    itemCount: listquests.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index){
                      double percentualdone = listquests[index].percentualDone();
                      var listqueststyle;
                      if(percentualdone==1.0){
                        listqueststyle = TextStyle(color: Colors.green, fontSize: 12.0, fontWeight: FontWeight.bold);
                      }
                      else{
                        listqueststyle = TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold);
                      }
                      return Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          width: 55.0,
                                          height: 55.0,
                                          child: CircleAvatar(
                                              backgroundColor: Color.fromRGBO(255, 211, 109, 0.4),
                                              foregroundColor: Color.fromRGBO(255, 211, 109, 0.4),
                                              backgroundImage: AssetImage(listquests[index].imagePath())
                                          )
                                      ),
                                      SizedBox(width: 5.0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(listquests[index].name, style: listqueststyle),
                                          LinearPercentIndicator(
                                            width: 140.0,
                                            lineHeight: 14.0,
                                            percent: percentualdone,
                                            backgroundColor: Colors.black,
                                            progressColor: Colors.green,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                    child: FlatButton(
                                      onPressed: (){
                                        Navigator.pushNamed(
                                          context,
                                          ExtractArgumentsScreen.routeName,
                                          arguments: listquests[index]
                                        );
                                      },
                                      color: Colors.amberAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: Text("Details", style: TextStyle(color: Colors.white))
                                    ),
                                  ),
                                  //Container(),
                                ],
                              )
                          )
                        ),
                      );
                    },
                  )
              );
            }
          },
        )
    );
  }
}

class ExtractArgumentsScreen extends StatefulWidget {
  static const routeName = 'extractArgumentsQuest';
  @override
  _ExtractArgumentsScreenState createState() => _ExtractArgumentsScreenState();
}

class _ExtractArgumentsScreenState extends State<ExtractArgumentsScreen> {
  @override
  Widget build(BuildContext context) {
    final Quest quest = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(quest.name),
        backgroundColor: Color.fromRGBO(255, 211, 109, 0.4),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: 55.0,
                          height: 55.0,
                          child: CircleAvatar(
                              backgroundColor: Color.fromRGBO(255, 211, 109, 0.4),
                              foregroundColor: Color.fromRGBO(255, 211, 109, 0.4),
                              backgroundImage: AssetImage(quest.imagePath())
                          )
                      ),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(quest.name, style: TextStyle(color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.bold)),
                          LinearPercentIndicator(
                            width: 140.0,
                            lineHeight: 14.0,
                            percent: quest.percentualDone(),
                            backgroundColor: Colors.black,
                            progressColor: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(16.0), child: Text(quest.xp.toString(), style: TextStyle(color: Colors.black, fontSize: 18.0)),),
                      Container(
                        width: 48.0,
                        height: 48.0,
                        child: Image.asset("assets/images/xp.png", height: 45.0, width: 45.0,),
                      )
                    ],
                  ),
                ],
              )
          ),
          ListView.builder(
              itemCount: quest.goal.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index){
                var color = Colors.white;
                var text_style;
                var icon;
                if(quest.goalStats[index]){
                  text_style = TextStyle(color: Colors.black, fontSize: 18.0, decoration: TextDecoration.lineThrough);
                  icon = Icon(Icons.check_circle, color: Colors.green, size: 32.0,);
                }
                else {
                  text_style = TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold);
                  icon = Icon(Icons.check_circle, color: Colors.orange, size: 32.0,);
                }
                return Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Card(
                    color: color,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(quest.goal[index], style: text_style,),
                                      Padding(padding: EdgeInsets.all(1.0)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Center(child: Icon(Icons.adjust, size: 10.0,)),
                                          Padding(padding: EdgeInsets.all(0.5)),
                                          Text("HORAS: "+quest.goalHours[index].toString()),
                                          Padding(padding: EdgeInsets.all(5.0)),
                                          Center(child: Icon(Icons.adjust, size: 10.0,)),
                                          Padding(padding: EdgeInsets.all(0.5)),
                                          Text("XP: "+quest.goalXp[index].toString())
                                        ],
                                      )
                                    ]
                                ),
                                IconButton(
                                  iconSize: 32.0,
                                  icon: icon,
                                  onPressed: (){
                                    setState(() {
                                      if(quest.goalStats[index]==true)
                                        quest.goalStats[index] = false;
                                      else
                                        quest.goalStats[index] = true;
                                      quest.save();
                                    });
                                  },
                                ),
                              ]
                          )
                      ),
                    ),
                  ),
                );
              }
          )
        ],
      )
    );
  }
}