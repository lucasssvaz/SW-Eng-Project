import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:job_adventure/models/quest.dart';
import 'package:job_adventure/Functions/guildFunctions.dart';
import 'package:job_adventure/models/user.dart';

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

  Future<void> getRead(String tokenUser) async{
    var thread1 = await _findAllCards(tokenUser);
    var thread2 = await boardyAlreadyQuest();
  }

  List<String> getListCardNames(String tokenUser){
    if(this._LoadCards){
      return _cardNames;
    }
    else{
      _findAllCards(tokenUser).then((str){return _cardNames;});
    }
  }

  List<String> getListCardIDs(String tokenUser){
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

//CLASSE INTERFACE PARA CRIACAO DE GUILDA A PARTIR DE UMA ORGANIZACAO DO TRELLO

//Para utilizacao dessa classe
//Primeiro, chamar a funcao "getListOrganizations(User user)" que retorna uma Future<List<organizationTrello>>
//dai jah sera possivel o acesso tanto dos nomes das organizacoes quanto dos IDs

//Para cada organizacao sera possivel
//Ao chamar o metodo ".getRead(User user)" ja estara disponivel a lista de Usuarios daquela Organizacao, ou seja, a lista de membros para uma Guilda configurada a partir disso
//tambem sera possivel acessar a lista de Boards (que virarao Quests depois) a partir daquela Guilda e sera possivel saber se o usuario em questao eh o GuildMaster ou nao
//Lista de usuarios -- ".getListMembers(User user)"
//Lista de Boards -- ".getListBoards(String tokenUser)"
//Eh ou nao o GuildMaster quando essa Guilda for configurada - ".isGuildMaster" atributo mesmo

//Para o acesso dos Boards utilizaremos os metodos de organizationTrello
//Para a verificacao de que se aquele Board ja foi configurado como uma Quest temos o metodo ".boardAlreadyQuest(int index, String tokenUser)"

//Para deixar pronto um Board para acesso utilize o metodo ".getReadBoard(int index, String tokenUser)"
//depois disso teremos acesso as informacoes das Cards desse Board como: Nome, ID, Stats
//Lista de Names -- ".getBoardListCardsNames(int index, String tokenUser)"
//Lista de IDs -- ".getBoardListCardsIDs(int index, String tokenUser)"
//Lista de Stats desses Boards (concluido ou nao) -- ".getBoardListCardsStats(int index, String tokenUser)"
//Ainda eh possivel para cada Board verificar se ele ja virou uma Quest
//".BoardyAlreadyQuest(int index, String tokenUser)"

//Por fim, temos as duas ultimas operacoes: Transformar a Board em Quest; transformar a Organizacao em Guild ou adicionar a organizacao as Quests
//Transformar a Board em Quest -- ".BoardToQuest(int index, List<int> goalHours, List<int> goalXp, int rewardItemId, int imgNumber, int xp, String tokenUser)"
//Criar uma Guilda ou adicionar as Quests configuradas nessa Guilda -- ".configurateGuild(String description, User user, String guildImage, String tokenUser)"

class organizationTrello{
  String id;
  String name;
  bool isGuildMaster;
  bool _guildExists;
  bool _boardsIsLoad;
  bool _membersIsLoad;
  List<String> _questIDsConfigured;
  List<String> _members;
  List<Board> _boards;

  organizationTrello(String id, User user){
    this.id = id;
    this.isGuildMaster = false;
    _boards = new List<Board>();
    _questIDsConfigured = new List<String>();
    _members = new List<String>();
    _boardsIsLoad = false;
    _membersIsLoad = false;
    _guildExists = false;
    _getOrganizationName(user.userKey).then((str){_checkGuildExists(user.userKey).then((str2){});});
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

  Future<void> _getListMembers(User user) async{
    String tokenUser = user.userKey;
    int i;
    String urlRequest = 'https://api.trello.com/1/organizations/'+this.id+'/memberships?filter=all&member=false&key='+APIKey+'&token='+tokenUser;
    final response = await get(urlRequest);
    List<dynamic> listIDMembers = json.decode(response.body);
    for(i=0;i<listIDMembers.length;i++){
      final responsemember = await get("https://api.trello.com/1/members/me/?key="+APIKey+"&token="+listIDMembers[i]['idMember']);
      var jsonresponse = json.decode(responsemember.body);
      this._members.add(jsonresponse['username']);
      if(jsonresponse['username']==user.name){
        List<dynamic> orgmember = json.decode(response.body);
        var isAdmin = orgmember[i]["memberType"];
        if(isAdmin=='admin')
          this.isGuildMaster = true;
        else
          this.isGuildMaster = false;
      }
    }
    this._membersIsLoad = true;
  }

  Future<void> getRead(User user) async{
    if(_boardsIsLoad==false){
      var thread = await _organizationBoards(user.userKey);
    }
    if(_membersIsLoad==false){
      var thread = await _getListMembers(user);
    }
  }

  List<String> getListMembers(User user){
    if(_membersIsLoad){
      return this._members;
    }
    else{
      var thread = _getListMembers(user).then((str){return this._members;});
    }
  }

  Future<void> getReadBoard(int index, String tokenUser) async{
    var thread = await _boards[index].getRead(tokenUser);
  }

  List<Board> getListBoards(String tokenUser){
    if(_boardsIsLoad){
      return _boards;
    }
    else{
      _organizationBoards(tokenUser).then((str){return _boards;});
    }
  }

  List<String> getBoardListCardsNames(int index, String tokenUser){
    if(_boardsIsLoad) {
        return _boards[index].getListCardNames(tokenUser);
    }
    else{
      _organizationBoards(tokenUser).then((void v){
        return getBoardListCardsNames(index, tokenUser);
      });
    }
  }

  List<String> getBoardListCardsIDs(int index, String tokenUser){
    if(_boardsIsLoad) {
        return _boards[index].getListCardIDs(tokenUser);
    }
    else{
      _organizationBoards(tokenUser).then((void v){
        return getBoardListCardsIDs(index, tokenUser);
      });
    }
  }

  List<bool> getBoardListCardsStats(int index, String tokenUser){
    if(_boardsIsLoad) {
        return _boards[index].getListCardStats(tokenUser);
    }
    else{
      _organizationBoards(tokenUser).then((void v){
        return getBoardListCardsStats(index, tokenUser);
      });
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

  Future<bool> BoardyAlreadyQuest(int index, String tokenUser) async{
    if(_boardsIsLoad){
      return _boards[index].boardyAlreadyQuest();
    }
    else{
      var thread = await _organizationBoards(tokenUser);
      return _boards[index].boardyAlreadyQuest();
    }
  }

  configurateGuild(String description, User user, String guildImage){
    if(_guildExists){
      insertQuestInGuild(this.name, _questIDsConfigured);
    }
    else {
      if (_membersIsLoad) {
        insertGuild(this.name, description, user.name, guildImage, _members, _questIDsConfigured);
      }
      else{
        _getListMembers(user).then((str){insertGuild(this.name, description, user.name, guildImage, _members, _questIDsConfigured);});
      }
      user.addGuild(this.name);
      user.save();
    }
    _addListQuestInListUsers(_questIDsConfigured, _members);
    _questIDsConfigured = new List<String>();
  }
}

Future<void> _addListQuestInListUsers(List<String> questIDs, List<String> userNames) async{
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

Future<List<organizationTrello>> getListOrganizations(User user)async{
  String urlRequest = "https://api.trello.com/1/members/me/?key="+APIKey+"&token="+user.userKey;
  var request = await get(urlRequest);
  List<String>organizationIDs = (json.decode(request.body))['idOrganizations'].cast<String>();
  List<organizationTrello> list = new List<organizationTrello>();
  for(int i=0;i<organizationIDs.length;i++){
    organizationTrello organization = new organizationTrello(organizationIDs[i], user);
    list.add(organization);
  }
  return list;
}