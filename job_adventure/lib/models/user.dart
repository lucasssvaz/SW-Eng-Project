import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

const String APIKey = "57a893b02ea2046b82ac861766a34bed";

class TrelloUserInformations{
  String username;
  String fullName;
  String avatarUrl;
  String email;
  TrelloUserInformations({this.username, this.fullName, this.avatarUrl, this.email});
}

Future<TrelloUserInformations> fetchPost(String url) async{
  final response = await get(url);
  var document = parse(response.body);
  var body = response.body;
  var jsonresponse = json.decode(body);
  //print(jsonresponse['username']);
  return await TrelloUserInformations(
    username: jsonresponse['username'],
    fullName: jsonresponse['fullName'],
    avatarUrl: jsonresponse['avatarUrl'],
    email: jsonresponse['email']
  );
}

initialRouteUser(String trelloKey) async{
  final trellopost = await fetchPost("https://api.trello.com/1/members/me/?key="+APIKey+"&token="+trelloKey);
  TrelloUserInformations trellouser = await trellopost;
  User ouruser = User(
    userName: trellouser.username,
    level: 0,
    xp: 0,
    name: trellouser.fullName,
    avatarUrl: trellouser.avatarUrl,
    email: trellouser.email,
    userKey: trelloKey,
    isAdmin: false,
    isGuildMaster: false,
    guildName: null,
    isAdventure: true,
    adminName: null,
    teamName: null
  );
  print(ouruser.name);
  ouruser.save();
}

class User{
  String userName;
  int level;
  int xp;
  String name;
  String avatarUrl;
  String email;
  String userKey;
  bool isAdmin;
  bool isGuildMaster;
  String guildName;
  bool isAdventure;
  String adminName;
  String teamName;

  User({this.userName,
  this.level,
  this.xp,
  this.name,
  this.avatarUrl,
  this.email,
  this.userKey,
  this.isAdmin,
  this.isGuildMaster,
  this.guildName,
  this.isAdventure,
  this.adminName,
  this.teamName});
  /*User(String trelloKey) async {
    String url = "https://api.trello.com/1/members/me/?key="+APIKey+"&token="+trelloKey;
    //final req = new Request("GET", Uri.parse(url));
    var test = fetchPost(url);
    var test2 = await test;
    TrelloUserInformations trellouser = test2;
      this.level = 0;
      this.userKey = trelloKey;
      this.isAdmin = false;
      this.isGuildMaster = false;
      this.isAdventure = true;
      this.guildName = null;
      this.isAdventure = true;
      this.adminName = null;
      this.teamName = null;
    //databaseReference.child(this.userName).set(toJson());
  }*/
  save(){
    Firestore.instance.collection('Users').document(this.userName).setData(toJson());
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
    guildName = json['guild_name'];
    isAdventure = json['is_adventure'];
    adminName = json['admin_name'];
    teamName = json['team_name'];
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
    data['guild_name'] = this.guildName;
    data['is_adventure'] = this.isAdventure;
    data['admin_name'] = this.adminName;
    data['team_name'] = this.teamName;
    return data;
  }
}