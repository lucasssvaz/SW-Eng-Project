import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:job_adventure/models/TrelloUtility.dart';

class Quest {
  Timer _timer;
  String id;
  String name;
  List<String> goal = [];
  List<String> goalID = [];
  List<bool> goalStats = [];
  List<int> goalHours = [];
  List<int> goalXp = [];
  int imgNumber;
  int rewardItemId;
  int xp;

  Quest.toLoad();

  Quest({
    this.id,
    this.name,
    this.goal,
    this.goalID,
    this.goalStats,
    this.goalHours,
    this.goalXp,
    this.rewardItemId,
    this.imgNumber,
    this.xp}){
    var userGet = Firestore.instance.collection('Quest').document(this.id).get();

    userGet.then((DocumentSnapshot doc)
    {
      if(this.imgNumber>5)
        this.imgNumber = 5;
      if(this.imgNumber<1)
        this.imgNumber = 1;
      if(doc.exists==false){
        save();
      }
      else{
        //Get data of the user and reload the User object
        var jsonfirestore = doc.data;
        fromJson(jsonfirestore);
      }
      this._timer = Timer.periodic(Duration(milliseconds: 60000),(Timer t) => _reload());//1 min to reload object values from firestore
    });
  }

  String imagePath(){
    return ("assets/images/quest"+this.imgNumber.toString()+".jpg");
  }
  double percentualDone(){
    int doneHours = 0;
    int TotalHours = 0;
    int i;
    for(i=0;i<goal.length;i++){
      TotalHours = TotalHours + goalHours[i];
      if(goalStats[i]==true)
        doneHours = doneHours + goalHours[i];
    }
    return ((1.0*doneHours)/(1.0*TotalHours));
  }

  save() async{
    //var usersRef = Firestore.instance.collection('Users').document(this.id);
    //var doc = await usersRef.get();
    Firestore.instance.collection('Quest').document(this.id).setData(toJson());
  }

  load(String IdQuest) async
  {
    DocumentSnapshot Snap = await Firestore.instance.collection('Quest').document(IdQuest).get();
    fromJson(Snap.data);

  }

  _reload() async{
    var userGet = Firestore.instance.collection('Quest').document(this.id).get();
    userGet.then((DocumentSnapshot doc) {
      //Get data of the user and reload the User object
      var jsonfirestore = doc.data;
      fromJson(jsonfirestore);
    });
  }

  updateCard(TrelloUtility myUtility, int i) async
  {
    myUtility.GoalSave(this, i);
  }

  updateBoard(TrelloUtility myUtility) async
  {
    myUtility.QuestSave(this);
  }

  fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.goal = json['goal'].cast<String>();
    this.goalID = json['goal_id'].cast<String>();
    this.goalStats = json['goal_stats'].cast<bool>();
    this.goalHours = json['goal_hours'].cast<int>();
    this.goalXp = json['goal_xp'].cast<int>();
    this.rewardItemId = json['reward_item_id'];
    this.xp = json['xp'];
    this.imgNumber = json['img_number'];
  }

  Quest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    goal = json['goal'].cast<String>();
    goalID = json['goal_id'].cast<String>();
    goalStats = json['goal_stats'].cast<bool>();
    goalHours = json['goal_hours'].cast<int>();
    goalXp = json['goal_xp'].cast<int>();
    rewardItemId = json['reward_item_id'];
    xp = json['xp'];
    imgNumber = json['img_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['goal'] = this.goal;
    data['goal_id'] = this.goalID;
    data['goal_stats'] = this.goalStats;
    data['goal_hours'] = this.goalHours;
    data['goal_xp'] = this.goalXp;
    data['reward_item_id'] = this.rewardItemId;
    data['xp'] = this.xp;
    data['img_number'] = this.imgNumber;
    return data;
  }

}