import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

const String APIKey = "57a893b02ea2046b82ac861766a34bed";

//to extract informations of trelloUser account
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
  //String test = await ouruser.save();
  //print('Cast test 2: '+test);
  ouruser.save();
}
//

//User class -- interface of iteration in Firebase Cloud collection: Users
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
  save() async{
    Firestore.instance.collection('Users').document(this.userName).setData(toJson());
    _save();
    //String test = await _read();
    //print('Cast test 1: '+test);
    return _read();
  }
  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'username';
    final value = prefs.getString(key) ?? 0;
    return value;
    //print('read: '+value);
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'username';
    final value = this.userName;
    prefs.setString(key, value);
    //print('saved '+value);
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