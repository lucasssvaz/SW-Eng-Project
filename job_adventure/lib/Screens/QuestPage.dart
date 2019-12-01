import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';

import '../models/quest.dart';
import 'package:flutter/material.dart';
import 'package:job_adventure/models/user.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ArgumentGoalPage{
  User user;
  Quest quest;
  ArgumentGoalPage({this.user, this.quest});
}

class QuestPage extends StatefulWidget {
  @override
  _QuestPageState createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    double c_width = MediaQuery.of(context).size.width*0.4;
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
              return Scaffold(
                  body: ListView.builder(
                    itemCount: listquests.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index){
                      double percentualdone = listquests[index].percentualDone();
                      var listqueststyle;
                      if(percentualdone==1.0){
                        listqueststyle = TextStyle(color: Colors.green, fontSize: 17.0, fontWeight: FontWeight.bold);
                      }
                      else{
                        listqueststyle = TextStyle(color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.bold);
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
                                          Container(
                                            width: c_width,
                                            child: Column(
                                              children: <Widget>[
                                                Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(removeQuestTitleTrelloPresets(listquests[index].name), style: listqueststyle)
                                                )
                                              ],
                                            ),
                                          ),
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
                                          arguments: new ArgumentGoalPage(user: user, quest: listquests[index])
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

String removeQuestTitleTrelloPresets(String title){
  return title.replaceAll('QuadroPessoal', '').replaceAll('QuadroCompartilhado', '');
}

class ExtractArgumentsScreen extends StatefulWidget {
  static const routeName = 'extractArgumentsQuest';
  @override
  _ExtractArgumentsScreenState createState() => _ExtractArgumentsScreenState();
}

class _ExtractArgumentsScreenState extends State<ExtractArgumentsScreen> {
  int currentTask;
  CounterGoalTimer relogioAtual;
  _ExtractArgumentsScreenState(){
    currentTask = -1;
  }

  @override
  Widget build(BuildContext context) {
    final ArgumentGoalPage args = ModalRoute.of(context).settings.arguments;
    final Quest quest = args.quest;
    final User user = args.user;
    var percentualdone = quest.percentualDone();
    double c_width = MediaQuery.of(context).size.width*0.45;
    var listqueststyle;
    if(percentualdone==1.0){
      listqueststyle = TextStyle(color: Colors.green, fontSize: 17.0, fontWeight: FontWeight.bold);
    }
    else{
      listqueststyle = TextStyle(color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.bold);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(removeQuestTitleTrelloPresets(quest.name)),
        backgroundColor: Color.fromRGBO(255, 211, 109, 0.4),
      ),
      body: ListView(
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
                          Container(
                            width: c_width,
                            child: Column(
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(removeQuestTitleTrelloPresets(quest.name), style: listqueststyle)
                                )
                              ],
                            ),
                          ),
                          LinearPercentIndicator(
                            width: 140.0,
                            lineHeight: 14.0,
                            percent: percentualdone,
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
                var iconclock;
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
                if(currentTask==index){
                  iconclock = Icon(Icons.timer, color: Colors.green, size: 20.0);
                }
                else{
                  iconclock = Icon(Icons.timer, color: Colors.red, size: 20.0);
                }
                double c_width = MediaQuery.of(context).size.width*0.6;
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
                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(2.0),
                                        width: c_width,
                                        child: Column(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(quest.goal[index], style: text_style,)
                                            )
                                          ],
                                        ),
                                      ),

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
                                          Text("XP: "+quest.goalXp[index].toString()),
                                          IconButton(
                                            icon: iconclock,
                                            onPressed: (){
                                              if(quest.goalStats[index]==false){
                                                if(currentTask==-1){
                                                  setState(() {
                                                    currentTask = index;
                                                    relogioAtual = new CounterGoalTimer(arqname: quest.goalID[index]);
                                                    relogioAtual.getPreviousTimer();
                                                  });
                                                }
                                                else if(index==currentTask){
                                                  relogioAtual.saveTime();
                                                  setState(() {
                                                    currentTask = -1;
                                                  });
                                                }
                                                else{
                                                  relogioAtual.saveTime();
                                                  setState(() {
                                                    currentTask = index;
                                                    relogioAtual = new CounterGoalTimer(arqname: quest.goalID[index]);
                                                    relogioAtual.getPreviousTimer();
                                                  });
                                                }
                                              }
                                            },
                                          )
                                        ],
                                      )
                                    ]
                                ),
                                IconButton(
                                  iconSize: 32.0,
                                  icon: icon,
                                  onPressed: (){
                                    setState(() {
                                      if(quest.goalStats[index]==false){
                                        if(currentTask==index){
                                          saveGoalTimerDatabaseAndStats(quest, index, relogioAtual.getTime(), true);
                                          relogioAtual.saveTime();
                                        }
                                        else{
                                          var savedTime = new CounterGoalTimer(arqname: quest.goalID[index]);
                                          savedTime.getPreviousTimer().then((str){
                                            saveGoalTimerDatabaseAndStats(quest, index, savedTime.initial_timer, true);
                                          });
                                        }
                                      }
                                      else{
                                        if(currentTask==index){
                                          saveGoalTimerDatabaseAndStats(quest, index, relogioAtual.getTime(), false);
                                          relogioAtual.saveTime();
                                        }
                                        else{
                                          var savedTime = new CounterGoalTimer(arqname: quest.goalID[index]);
                                          savedTime.getPreviousTimer().then((str){
                                            saveGoalTimerDatabaseAndStats(quest, index, savedTime.initial_timer, false);
                                          });
                                        }
                                      }
                                      if (quest.goalStats[index] == true) {
                                        quest.goalStats[index] = false;
                                        changeQuestGoal(user, quest, index, false);
                                      }
                                      else {
                                        if(currentTask==index)
                                          currentTask = -1;
                                        quest.goalStats[index] = true;
                                        changeQuestGoal(user, quest, index, true);
                                      }
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

void saveGoalTimerDatabaseAndStats(Quest quest, int goalIndex, int seconds, bool stats) async{
  final ref = await Firestore.instance.collection('Quest').document(quest.id);
  var questDatabase = await ref.get();
  List<double> listHours;
  List<bool> goalStats;

  if(questDatabase.data['goal_stats']!=null)
    goalStats = questDatabase.data['goal_stats'].cast<bool>();
  else
    goalStats = new List<bool>(quest.goal.length);

  if(questDatabase.data['goal_done_hours']!=null)
    listHours = questDatabase.data['goal_done_hours'].cast<double>();
  else
    listHours = new List<double>(quest.goal.length);

  listHours[goalIndex] = (seconds/3600);
  goalStats[goalIndex] = stats;
  questDatabase.data['goal_done_hours'] = listHours;
  questDatabase.data['goal_stats'] = goalStats;
  await ref.setData(questDatabase.data);
}