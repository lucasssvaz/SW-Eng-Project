import '../models/quest.dart';
import 'package:flutter/material.dart';

class QuestPage extends StatefulWidget {
  var quests = new List<Quest>();

  //only to see a peace of this Quest Page
  QuestPage() {
    quests = [];
    quests.add(Quest(
        id: 1,
        name: "Criar um tema",
        goal: [
          "Escolher um estilo de fontes",
          "Escolher um estilo de cards",
          "Criar uma minuatura",
          "Criar um layout"
        ],
        goalStats: [false, false, true, false],
        goalHours: [4, 4, 4, 4],
        goalXp: [95,100,5,10],
        rewardItemId: 5,
        xp: 150
    ));

    quests.add(Quest(
        id: 2,
        name: "Teste",
        goal: ["Testando"],
        goalStats: [true],
        goalHours: [1],
        goalXp: [0],
        rewardItemId: -1,
        xp: 10
    ));
  }

  @override
  _QuestPage createState() => _QuestPage();
}
  
class _QuestPage extends State<QuestPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(10),
              itemCount: widget.quests.length,
              itemBuilder: (BuildContext context, int index){
                return new GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(
                      context,
                      ExtractArgumentsScreen.routeName,
                      arguments: widget.quests[index]
                    );
                  },
                  child: Container(
                    height: 50,
                    color: Color.fromRGBO(255, 211, 109, 0.4),
                     child: Center(child: Text('${widget.quests[index].name}'))
                  ),
                );
              }, separatorBuilder: (BuildContext context, int index) => const Divider(),
            )
          )
        ],
      )
    );
  }
}

class ExtractArgumentsScreen extends StatelessWidget {
  static const routeName = 'extractArgumentsQuest';

  @override
  Widget build(BuildContext context) {
    // Extract the arguments from the current ModalRoute settings and cast
    // them as ScreenArguments.
    final Quest args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.name),
        backgroundColor: Color.fromRGBO(255, 211, 109, 0.4),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(10),
              itemCount: args.goal.length,
              itemBuilder: (BuildContext context, int index){
                if(args.goalStats[index]==false) {
                  return Container(
                      height: 30,
                      color: Color.fromRGBO(255, 211, 109, 0.4),
                      child:  Row(
                        children: <Widget>[
                          Container(
                            height: 30,
                            width: 250,
                            child: Center(child: Text('${args.goal[index]}')),
                          ),
                          Text(args.goalXp[index].toString()),
                          Icon(Icons.monetization_on, color: Colors.teal)
                        ],
                      ) ,
                  );
                }
                else{
                  return Container(
                      height: 25,
                      color: Color.fromRGBO(255, 211, 109, 0.4),
                      child:  Row(
                        children: <Widget>[
                          Container(
                            height: 30,
                            width: 250,
                            child: Center(child: Text('${args.goal[index]}', style: TextStyle(fontWeight: FontWeight.bold))),
                          ),
                          Text(args.goalXp[index].toString()),
                          Icon(Icons.monetization_on, color: Colors.cyanAccent,),
                          Container(
                            height: 30,
                            width: 30,
                            child: Icon(Icons.check_circle_outline)
                          )
                        ],
                      ) ,
                  );
                }
              }, separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
          )
        ],
      ),
    );
  }
}