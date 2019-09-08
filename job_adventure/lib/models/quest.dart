import 'package:flutter/material.dart';

class Quest {
  int id;
  String name;
  List<String> goal;
  List<bool> goalStats;
  List<int> goalHours;
  int rewardItemId;
  int xp;

  Quest(
      {this.id,
      this.name,
      this.goal,
      this.goalStats,
      this.goalHours,
      this.rewardItemId,
      this.xp});

  Quest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    goal = json['goal'].cast<String>();
    goalStats = json['goal_stats'].cast<bool>();
    goalHours = json['goal_hours'].cast<int>();
    rewardItemId = json['reward_item_id'];
    xp = json['xp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['goal'] = this.goal;
    data['goal_stats'] = this.goalStats;
    data['goal_hours'] = this.goalHours;
    data['reward_item_id'] = this.rewardItemId;
    data['xp'] = this.xp;
    return data;
  }
}

class QuestWidget extends StatefulWidget {
  final Quest quest;

  QuestWidget(this.quest);
  @override
  _QuestWidgetState createState() => _QuestWidgetState(quest);
}

class _QuestWidgetState extends State<QuestWidget> {
  Quest quest;
  _QuestWidgetState(Quest quest){
    this.quest = quest;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(quest.name),
        ),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.all(10),
                      itemCount: quest.goal.length,
                      itemBuilder: (BuildContext context, int index){
                        return Container(
                            height: 25,
                            color: Color.fromRGBO(255, 211, 109, 0.4),
                            child: Center(child: Text('${quest.goal[index]}'))
                        );
                      }, separatorBuilder: (BuildContext context, int index) => const Divider(),
                    )
                )
              ],
            )
        )
    );
  }
}

/*class QuestWidget extends StatefulWidget {
  final Quest quest;
  QuestWidget(id, name, goal, goalStats, goalHours, rewardItemId, xp){
    quest(id, name, goal, goalStats, goalHours, rewardItemId, xp);
  }
  _QuestWidgetState createState() => _QuestWidgetState(quest);
}

class _QuestWidgetState extends State<QuestWidget> {
  final Quest quest;
  _QuestWidgetState({this.quest});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(user.name),
        ),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
              user.
              ],
            )
        )
    );
  }
}*/