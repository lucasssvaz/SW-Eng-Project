import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:job_adventure/models/quest.dart';
import 'package:job_adventure/Functions/guildFunctions.dart';

const String APIKey = "57a893b02ea2046b82ac861766a34bed";


//Nao Use os metodos de Board, mas use os metodos de TrelloOrganization
class Board{
  String id;
  String name;
  List<String> _cardIDs;
  List<String> _cardNames;
  List<bool> _cardStats;
  bool _LoadCards;

  Board({this.id, this.name}){
    this._cardIDs = new List<String>();
    this._cardNames = new List<String>();
    this._cardStats = new List<bool>();
    this._LoadCards = false;
  }

  Future<bool> boardyAlreadyQuest()async{
    var doc = (await Firestore.instance.collection('Quest').document(this.id).get());
    return doc.exists;
  }

  Future<void> _findAllCards(String tokenUser) async{
    String urlRequest = "https://api.trello.com/1/boards/"  + this.id +  "?cards=all&key="+APIKey+"&token="+tokenUser;
    final response = await get(urlRequest);
    var jsonreponse = json.decode(response.body);
    List<dynamic> cards = jsonreponse['cards'];
    int i;
    for(i=0;i<cards.length;i++){
      _cardIDs.add(cards[i]['id']);
      _cardNames.add(cards[i]['name']);
      _cardStats.add(cards[i]['closed']);
    }
    this._LoadCards = true;
  }

  Future<void> getListCardRead(String tokenUser) async{
    var thread = await _findAllCards(tokenUser);
  }

  List<String> getListCardNames(String tokenUser){
    if(this._LoadCards){
      return _cardNames;
    }
    else{
      _findAllCards(tokenUser).then((str){return _cardNames;});
    }
  }

  List<String> getListCardIds(String tokenUser){
    if(this._LoadCards){
      return _cardIDs;
    }
    else{
      _findAllCards(tokenUser).then((str){return _cardIDs;});
    }
  }

  List<bool> getListCardStats(String tokenUser){
    if(this._LoadCards){
      return _cardStats;
    }
    else{
      _findAllCards(tokenUser).then((str){return _cardStats;});
    }
  }

  toQuest(List<int> goalHours, List<int> goalXp, int rewardItemId, int imgNumber, int xp, String tokenUser){
    if(this._LoadCards){
      Quest quest = Quest(
        id: this.id,
        name: this.name,
        goal: this._cardNames,
        goalID: this._cardIDs,
        goalStats: this._cardStats,
        goalHours: goalHours,
        goalXp: goalXp,
        rewardItemId: rewardItemId,
        imgNumber: imgNumber,
        xp: xp
      );
    }
    else{
      _findAllCards(tokenUser).then((str){this.toQuest(goalHours, goalXp, rewardItemId, imgNumber, xp, tokenUser);});
    }
  }
}

class organizationTrello{
  String id;
  String name;

  bool _guildExists;
  bool _boardsIsLoad;
  bool _membersIsLoad;
  List<String> _questIDsConfigured;
  List<String> _members;
  List<Board> _boards;

  organizationTrello(String id, String tokenUser){
    this.id = id;
    _boards = new List<Board>();
    _questIDsConfigured = new List<String>();
    _members = new List<String>();
    _boardsIsLoad = false;
    _membersIsLoad = false;
    _guildExists = false;
    _getOrganizationName(tokenUser).then((str){_checkGuildExists(tokenUser).then((str2){});});
  }
  Future<void> _getOrganizationName(String tokenUser) async{
    String urlRequest = "https://api.trello.com/1/organizations/"+this.id+"?key="+APIKey+"&token="+tokenUser;
    final response = await get(urlRequest);
    var jsonresponse = json.decode(response.body);
    this.name = jsonresponse['displayName'];
  }

  Future<void> _checkGuildExists(String tokenUser) async{
    var doc = await Firestore.instance.collection('Guilds').document(this.name).get();
    this._guildExists = doc.exists;
  }

  Future<void> _organizationBoards(String tokenUser) async{
    List<dynamic> cards = new List<dynamic>();
    String urlRequest = "https://api.trello.com/1/organizations/"+this.id+"/boards?filter=all&fields=all&key="+APIKey+"&token="+tokenUser;
    var response = await get(urlRequest);
    List<dynamic> teamInfo = json.decode(response.body);
    int i;
    for(i=0;i<teamInfo.length;i++){
      _boards.add(Board(id: teamInfo[i]['id'], name: teamInfo[i]['name']));
    }
    _boardsIsLoad = true;
  }

  Future<void> _getListMembers(String tokenUser) async{
    int i;
    String urlRequest = 'https://api.trello.com/1/organizations/'+this.id+'/memberships?filter=all&member=false&key='+APIKey+'&token='+tokenUser;
    final response = await get(urlRequest);
    List<dynamic> listIDMembers = json.decode(response.body);
    for(i=0;i<listIDMembers.length;i++){
      final responsemember = await get("https://api.trello.com/1/members/me/?key="+APIKey+"&token="+listIDMembers[i]['idMember']);
      var jsonresponse = json.decode(responsemember.body);
      this._members.add(jsonresponse['username']);
    }
    this._membersIsLoad = true;
  }

  Future<void> getRead(String tokenUser) async{
    if(_boardsIsLoad==false){
      var thread = await _organizationBoards(tokenUser);
    }
    if(_membersIsLoad==false){
      var thread = await _getListMembers(tokenUser);
    }
  }

  List<String> getListMembers(String tokenUser){
    if(_membersIsLoad){
      return this._members;
    }
    else{
      var thread = _getListMembers(tokenUser).then((str){return this._members;});
    }
  }


  List<Board> getListBoards(String tokenUser){
    if(_boardsIsLoad){
      return _boards;
    }
    else{
      _organizationBoards(tokenUser).then((str){return _boards;});
    }
  }

  Future<List<String>> getBoardListCardsNames(int index, String tokenUser) async{
    if(_boardsIsLoad) {
      if (index < _boards.length) {
        var thread = await _boards[index].getListCardNames(tokenUser);
      }
      else {
        List<String> ret = new List<String>();
        return ret;
      }
    }
    else{
      var thread = await _organizationBoards(tokenUser);
      return getBoardListCardsNames(index, tokenUser);
    }
  }

  Future<List<String>> getBoardListCardsIds(int index, String tokenUser) async{
    if(_boardsIsLoad) {
      if (index < _boards.length) {
        var thread = await _boards[index].getListCardIds(tokenUser);
      }
      else {
        List<String> ret = new List<String>();
        return ret;
      }
    }
    else{
      var thread = await _organizationBoards(tokenUser);
      return getBoardListCardsIds(index, tokenUser);
    }
  }

  Future<List<String>> getBoardListCardsStats(int index, String tokenUser) async{
    if(_boardsIsLoad) {
      if (index < _boards.length) {
        var thread = await _boards[index].getListCardStats(tokenUser);
      }
      else {
        List<String> ret = new List<String>();
        return ret;
      }
    }
    else{
      var thread = await _organizationBoards(tokenUser);
      return getBoardListCardsStats(index, tokenUser);
    }
  }

  Future<void> BoardToQuest(int index, List<int> goalHours, List<int> goalXp, int rewardItemId, int imgNumber, int xp, String tokenUser) async{
    if(_boardsIsLoad){
      if(index < _boards.length){
        var thread = await _boards[index].boardyAlreadyQuest();
        if(thread==false) {
          _boards[index].toQuest(
              goalHours, goalXp, rewardItemId, imgNumber, xp, tokenUser);
          _questIDsConfigured.add(_boards[index].id);
        }
      }
    }
    else{
      var thread = await _organizationBoards(tokenUser);
      return BoardToQuest(index, goalHours, goalXp, rewardItemId, imgNumber, xp, tokenUser);
    }
  }

  createGuild(String description, String userName, String guildImage, String tokenUser){
    if(_guildExists){
      insertQuestInGuild(this.name, _questIDsConfigured);
    }
    else {
      if (_membersIsLoad) {
        insertGuild(this.name, description, userName, guildImage, _members, _questIDsConfigured);
      }
      else{
        _getListMembers(tokenUser).then((str){insertGuild(this.name, description, userName, guildImage, _members, _questIDsConfigured);});
      }
    }
    addListQuestInListUsers(_questIDsConfigured, _members);
    _questIDsConfigured = new List<String>();
  }
}

Future<void> addListQuestInListUsers(List<String> questIDs, List<String> userNames) async{
  int i, j;
  for(i=0;i<userNames.length;i++){
    var firebase = (await Firestore.instance.collection('Users').document(userNames[i]).get());
    if(firebase.exists) {
      var jsonUser = firebase.data;
      var quests = jsonUser['quest_id'].cast<String>();
      for (j = 0; j < questIDs.length; j++) {
        quests.add(questIDs[j]);
      }
      jsonUser['quest_id'] = quests;
      var thread = await Firestore.instance.collection('Users').document(userNames[i]).setData(jsonUser);
    }
  }
}