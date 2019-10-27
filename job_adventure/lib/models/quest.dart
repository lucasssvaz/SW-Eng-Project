import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:job_adventure/models/TrelloBoard.dart';
import 'package:job_adventure/models/TrelloUtility.dart';
import 'package:job_adventure/models/user.dart';
import 'package:job_adventure/Functions/guildFunctions.dart';

const String APIKey = "57a893b02ea2046b82ac861766a34bed";

class Quest {
  Timer _timer;
  String id;
  String name;
  String guildName;
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
    this.guildName,
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
    if(goal.length==0)
      return 0;
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
    this.guildName = json['guild_name'];
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
    guildName = json['guild_name'];
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
    data['guild_name'] = this.guildName;
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


//LEON -- VOU USAR ESSAS FUNCOES PRA DAR UPDATE NAS BOARDS E CARDS
Future<void> chanceCardStats(String cardID, String tokenUser, bool set) async{
  String urlRequest = 'https://api.trello.com/1/cards/'+cardID+'?dueComplete='+set.toString()+'&key='+APIKey+'&token='+tokenUser;
  var request = await put(urlRequest);
}

Future<void> changeBoardStats(String boardID, String tokenUser, bool set) async{
  String urlRequest = 'https://api.trello.com/1/boards/'+boardID+'?closed='+set.toString()+'&key='+APIKey+'&token='+tokenUser;
  var request = await put(urlRequest);
}

Future<void> changeQuestGoal(User user, Quest quest, int index, bool set) async{
  String tokenUser = user.userKey;
  double previusPercentual = quest.percentualDone();
  var thread = await chanceCardStats(quest.goalID[index], tokenUser, set);
  //quest.goalStats[index] = set; -- Problema de threads, setar isso na pagina, depois chamar a funcao que trabalhara para alterar no banco de dados e no trello isso
  //quest.save();
  if(set){
    if(quest.guildName!=null)
      increaseGuildMemberXP(quest.guildName, user.userName, quest.goalXp[index]);
    user.addXp(quest.goalXp[index]);
  }
  else{
    if(quest.guildName!=null)
      increaseGuildMemberXP(quest.guildName, user.userName, (-1)*quest.goalXp[index]);
    user.addXp((-1)*quest.goalXp[index]);
  }
  double newPercentual = quest.percentualDone();
  if(previusPercentual==1.0 && set==false){
    var thread = await changeBoardStats(quest.id, tokenUser, set);
    if(quest.guildName!=null)
      increaseGuildMemberXP(quest.guildName, user.userName, (-1)*quest.xp);
    user.addXp((-1)*quest.goalXp[index]);
  }
  if(previusPercentual!=1.0 && newPercentual==1.0){
    var thread = await changeBoardStats(quest.id, tokenUser, set);
    if(quest.guildName!=null)
      increaseGuildMemberXP(quest.guildName, user.userName, quest.xp);
    user.addXp(quest.goalXp[index]);
  }
  user.save();
}