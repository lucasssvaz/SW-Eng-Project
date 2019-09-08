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
        goalStats: [false, false, false, false],
        goalHours: [4, 4, 4, 4],
        rewardItemId: 5,
        xp: 150
    ));

    quests.add(Quest(
        id: 2,
        name: "Teste",
        goal: ["Testando"],
        goalStats: [true],
        goalHours: [1],
        rewardItemId: -1,
        xp: 0
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
  static const routeName = 'extractArguments';

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
                return Container(
                  height: 25,
                  color: Color.fromRGBO(255, 211, 109, 0.4),
                  child: Center(child: Text('${args.goal[index]}'))
                );
              }, separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
          )
        ],
      ),
    );
  }
}