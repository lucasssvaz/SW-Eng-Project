import 'package:http/http.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:job_adventure/models/TrelloUtility.dart';
import 'package:job_adventure/models/quest.dart';
import 'package:job_adventure/models/TrelloBoard.dart';

const String APIKey = "57a893b02ea2046b82ac861766a34bed";

final storage = new FlutterSecureStorage();

//to extract informations of trelloUser account

Future<User> initialRoute(String trelloKey) async{
  print("Key do trello: "+trelloKey);
  final response = await get("https://api.trello.com/1/members/me/?key="+APIKey+"&token="+trelloKey);
  var jsonresponse = json.decode(response.body);

  TrelloUtility myUtility = new TrelloUtility(trelloKey);
  List<Quest> AllQuests = await myUtility.InitialTrelloUtility(true);

/*
  TrelloBoards UserBoards = new TrelloBoards(trelloKey);
  await UserBoards.FindAllBoards(trelloKey);
*/

  List<String> quests = [];

  for(int i = 0; i < AllQuests.length; i++)
  {
    Quest aux = AllQuests[i];
    quests.add(aux.id);
  }

  User user =  User(
    userName: jsonresponse['username'],
    level: 0,
    xp: 0,
    name: jsonresponse['fullName'],
    avatarUrl: jsonresponse['avatarUrl'],
    email: jsonresponse['email'],
    userKey: trelloKey,
    isAdmin: false,
    isGuildMaster: false,
    guildNameGuildMaster: null,
    isAdventure: true,
    adminName: null,
    teamName: null,
    questID: quests
  );
  user.MyUtility = myUtility;
  return user;
}

//User class -- interface of iteration in Firebase Cloud collection: Users
class User{
  Timer _timer;
  String userName;
  int level;
  int xp;
  String name;
  String avatarUrl;
  String email;
  String userKey;
  bool isAdmin;
  bool isGuildMaster;
  List<String> guildNameGuildMaster;
  bool isAdventure;
  String adminName;
  String teamName;
  List<String> questID;
  TrelloUtility MyUtility;

  User({this.userName,
  this.level,
  this.xp,
  this.name,
  this.avatarUrl,
  this.email,
  this.userKey,
  this.isAdmin,
  this.isGuildMaster,
  this.guildNameGuildMaster,
  this.isAdventure,
  this.adminName,
  this.teamName,
  this.questID})
  {
    if(questID == null)
      this.questID = new List<String>();

    var userGet = Firestore.instance.collection('Users').document(this.userName).get();
    userGet.then((DocumentSnapshot doc) {
      if(doc.exists)
      {
        //Get data of the user and reload the User object

        var jsonfirestore = doc.data;

        List<String> newQuests = this.questID;
        fromJson(jsonfirestore);
        this.questID = newQuests;
      }
      save();
      this._timer = Timer.periodic(Duration(milliseconds: 60000),(Timer t) => _reload());//1 min to reload object values from firestore
    });
  }

  addXp(int amount){
    var userXp = Firestore.instance.collection('Level').document('xp').get();
    userXp.then((DocumentSnapshot doc){
      var jsonfirestore = doc.data;
      int qLevelXp = jsonfirestore[this.level.toString()];
      this.xp = this.xp + amount;
      if(qLevelXp!=null){
        while(this.xp>qLevelXp){
          this.xp = this.xp - qLevelXp;
          this.level ++;
        }
      }
    });
    save();
  }

  Future<List<Quest>> getQuests() async{
    int i=0;
    List<Quest> list = new List<Quest>();
    while(i<questID.length){
      var questdoc = Firestore.instance.collection('Quest').document(this.questID[i]).get();
      list.add(Quest.fromJson((await questdoc).data));
      i++;
    }
    return list;
  }

  addQuest(String questId){
    int i;
    bool add=true;
    for(i=0;i<this.questID.length&&add==true;i++){
      if(this.questID[i]==questId)
        add=false;
    }
    if(this.questID==null)
      this.questID = new List<String>();
    if(add==true) {
      this.questID.add(questId);
    }
  }

  addGuild(String guildName){
    if(isGuildMaster==false)
      isGuildMaster = true;
    if(guildNameGuildMaster==null)
      guildNameGuildMaster = new List<String>();
    guildNameGuildMaster.add(guildName);
  }

  chanceAvatarUrl(int i){//Vet indice image in our list
  }

  setAdmin(String userName){
    if(this.isAdmin==true) {
      var userGet = Firestore.instance.collection('Users')
          .document(userName)
          .get();
      userGet.then((DocumentSnapshot doc) {
        User objUser = User.fromJson(doc.data);
        objUser.isAdmin = true;
        objUser.isAdventure = false;
        objUser.isGuildMaster = false;
        objUser.guildNameGuildMaster = null;
        objUser.questID = null;
        objUser.adminName = this.name;
        objUser.save();
      });
    }
  }

  save() async{
    var usersRef = Firestore.instance.collection('Users').document(this.userName);
    var doc = await usersRef.get();
    Firestore.instance.collection('Users').document(this.userName).setData(toJson());
  }

  fromJson(Map<String, dynamic> json) {
    this.level = json['level'];
    this.xp = json['xp'];
    this.name = json['name'];
    this.avatarUrl = json['avatar_url'];
    this.email = json['email'];
    this.userKey = json['user_key'];
    this.isAdmin = json['is_admin'];
    this.isGuildMaster = json['is_guild_master'];
    this.guildNameGuildMaster = json['guild_name'].cast<String>();
    this.isAdventure = json['is_adventure'];
    this.adminName = json['admin_name'];
    this.teamName = json['team_name'];
    this.questID = json['quest_id'].cast<String>();
  }

  User.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    xp = json['xp'];
    name = json['name'];
    avatarUrl = json['avatar_url'];
    email = json['email'];
    userKey = json['user_key'];
    isAdmin = json['is_admin'];
    isGuildMaster = json['is_guild_master'];
    guildNameGuildMaster = json['guild_name'].cast<String>();
    isAdventure = json['is_adventure'];
    adminName = json['admin_name'];
    teamName = json['team_name'];
    questID = json['quest_id'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    data['xp'] = this.xp;
    data['name'] = this.name;
    data['avatar_url'] = this.avatarUrl;
    data['email'] = this.email;
    data['user_key'] = this.userKey;
    data['is_admin'] = this.isAdmin;
    data['is_guild_master'] = this.isGuildMaster;
    data['guild_name'] = this.guildNameGuildMaster;
    data['is_adventure'] = this.isAdventure;
    data['admin_name'] = this.adminName;
    data['team_name'] = this.teamName;
    data['quest_id'] = this.questID;
    return data;
  }

  _reload() async{
    var userGet = Firestore.instance.collection('Users').document(this.userName).get();
    userGet.then((DocumentSnapshot doc) {
        //Get data of the user and reload the User object
        var jsonfirestore = doc.data;
        fromJson(jsonfirestore);
    });
  }
}