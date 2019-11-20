import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:job_adventure/models/quest.dart';
import 'package:job_adventure/Functions/guildFunctions.dart';
import 'package:job_adventure/models/user.dart';

const String APIKey = "57a893b02ea2046b82ac861766a34bed";

//Nao Use os metodos de Board, mas use os metodos de TrelloOrganization
class Board {
  String id;
  String name;
  List<String> _cardIDs;
  List<String> _cardNames;
  List<bool> _cardStats;
  bool _LoadCards;
  bool boardIsQuest;

  Board({this.id, this.name}) {
    this._cardIDs = new List<String>();
    this._cardNames = new List<String>();
    this._cardStats = new List<bool>();
    this._LoadCards = false;
    this.boardIsQuest = false;
  }

  Future<bool> boardyAlreadyQuest() async {
    var doc =
        (await Firestore.instance.collection('Quest').document(this.id).get());
    this.boardIsQuest = doc.exists;
    return doc.exists;
  }

  Future<void> _findAllCards(String tokenUser) async {
    String urlRequest = "https://api.trello.com/1/boards/" +
        this.id +
        "?cards=all&key=" +
        APIKey +
        "&token=" +
        tokenUser;
    final response = await get(urlRequest);
    var jsonreponse = json.decode(response.body);
    List<dynamic> cards = jsonreponse['cards'];
    int i;
    _cardIDs = new List<String>();
    _cardNames = new List<String>();
    _cardStats = new List<bool>();
    for (i = 0; i < cards.length; i++) {
      _cardIDs.add(cards[i]['id']);
      _cardNames.add(cards[i]['name']);
      _cardStats.add(cards[i]['closed']);
    }
    this._LoadCards = true;
  }

  Future<void> getRead(String tokenUser) async {
    var thread1 = await _findAllCards(tokenUser);
    var thread2 = await boardyAlreadyQuest();
  }

  List<String> getListCardNames(String tokenUser) {
    return _cardNames;
  }

  List<String> getListCardIDs(String tokenUser) {
    if (this._LoadCards) {
      return _cardIDs;
    } else {
      _findAllCards(tokenUser).then((str) {
        return _cardIDs;
      });
    }
  }

  List<bool> getListCardStats(String tokenUser) {
    if (this._LoadCards) {
      return _cardStats;
    } else {
      _findAllCards(tokenUser).then((str) {
        return _cardStats;
      });
    }
  }

  toQuest(String guildName, List<int> goalHours, List<int> goalXp, int rewardItemId,
      int imgNumber, int xp, String tokenUser) {
    if (this._LoadCards) {
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
          xp: xp);
      quest.goalHours = goalHours;
      quest.goalXp = goalXp;
      quest.rewardItemId = rewardItemId;
      quest.imgNumber = imgNumber;
      quest.guildName = guildName;
      quest.xp = xp;
      print('Salvando');
      quest.save();
    } else {
      _findAllCards(tokenUser).then((str) {
        this.toQuest(guildName, goalHours, goalXp, rewardItemId, imgNumber, xp, tokenUser);
      });
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

class organizationTrello {
  String id;
  String name;
  bool isGuildMaster;
  bool _guildExists;
  bool _boardsIsLoad;
  bool _membersIsLoad;
  List<String> _questIDsConfigured;
  List<String> _membersID;
  List<String> _membersNames;
  List<Board> _boards;

  organizationTrello(String id, User user) {
    this.id = id;
    this.isGuildMaster = false;
    _boards = new List<Board>();
    _questIDsConfigured = new List<String>();
    _membersID = new List<String>();
    _membersNames = new List<String>();
    _boardsIsLoad = false;
    _membersIsLoad = false;
    _guildExists = false;
    _getOrganizationName(user.userKey).then((str) {
      _checkGuildExists(user.userKey).then((str2) {});
    });
  }
  Future<void> _getOrganizationName(String tokenUser) async {
    String urlRequest = "https://api.trello.com/1/organizations/" +
        this.id +
        "?key=" +
        APIKey +
        "&token=" +
        tokenUser;
    final response = await get(urlRequest);
    var jsonresponse = json.decode(response.body);
    this.name = jsonresponse['displayName'];
  }

  Future<void> _checkGuildExists(String tokenUser) async {
    var doc =
        await Firestore.instance.collection('Guilds').document(this.name).get();
    this._guildExists = doc.exists;
  }

  Future<void> _organizationBoards(String tokenUser) async {
    List<dynamic> cards = new List<dynamic>();
    String urlRequest = "https://api.trello.com/1/organizations/" +
        this.id +
        "/boards?filter=all&fields=all&key=" +
        APIKey +
        "&token=" +
        tokenUser;
    var response = await get(urlRequest);
    List<dynamic> teamInfo = json.decode(response.body);
    int i;
    _boards = new List<Board>();
    for (i = 0; i < teamInfo.length; i++) {
      _boards.add(Board(id: teamInfo[i]['id'], name: teamInfo[i]['name']));
    }
    _boardsIsLoad = true;
  }

  Future<void> _getListMembers(User user) async {
    String tokenUser = user.userKey;
    int i;
    String urlRequest = 'https://api.trello.com/1/organizations/' +
        this.id +
        '/memberships?filter=all&member=false&key=' +
        APIKey +
        '&token=' +
        tokenUser;
    final response = await get(urlRequest);

    dynamic listIDMembers = json.decode(response.body);

    for (i = 0; i < listIDMembers.length; i++) {
      final responsemember = await get('https://api.trello.com/1/members/' +
          listIDMembers[i]['idMember'] +
          '?boardBackgrounds=none&boardsInvited_fields=name%2Cclosed%2CidOrganization%2Cpinned&boardStars=false&cards=none&customBoardBackgrounds=none&customEmoji=none&customStickers=none&fields=all&organizations=none&organization_fields=all&organization_paid_account=false&organizationsInvited=none&organizationsInvited_fields=all&paid_account=false&savedSearches=false&tokens=none&key=' +
          APIKey +
          '&token=' +
          user.userKey);
      var jsonresponse = json.decode(responsemember.body);
      this._membersID.add(jsonresponse['username']);
      this._membersNames.add(jsonresponse['fullName']);

      if (listIDMembers[i]['memberType'] == 'admin') {
        if (jsonresponse['username'] == user.userName &&
            isGuildMaster == false) {
          this.isGuildMaster = true;
        }
      }
    }
    this._membersIsLoad = true;
  }

  //Metodo que deixa pronta a primeira camada de detalhes da configuracao da Guilda, esses detalhes incluem a lista de boards acessivel e a lista de membros
  Future<bool> getRead(User user) async {
    if (_boardsIsLoad == false) {
      var thread1 = await _organizationBoards(user.userKey);
    }
    if (_membersIsLoad == false) {
      var thread2 = await _getListMembers(user);
    }
    return this.isGuildMaster;
  }

  //Metodo que verifica se a Guilda jah existe -- ainda nao utilizado
  //nao utilizado pois na finalizacao da configuracao da Guilda o metodo utilizado verifica se isso eh verdade e se sim soh adiciona mais Quests aquela Guilda
  bool organizationAlreadyGuild() {
    return this._guildExists;
  }

  //Metodo que pega a lista de IDs (usernames) dos membros do TeamTrello
  List<String> getListMembersID(User user) {
    if (_membersIsLoad) {
      return this._membersID;
    } else {
      var thread = _getListMembers(user).then((str) {
        return this._membersID;
      });
    }
  }

  //Metodo que pega a lista de nomes (fullname) dos membros do TeamTrello
  List<String> getListMembersNames(User user) {
    if (_membersIsLoad) {
      return this._membersNames;
    } else {
      var thread = _getListMembers(user).then((str) {
        return this._membersNames;
      });
    }
  }

  //Metodo que deixa pronta a camada Board de um dado Board do TeamTrello, o Board eh especificado pelo index
  //Esse metodo prepara os campos de todos os Cards (ID, Name, Stats) de um Board e a verificacao de que se aquele Board ja eh uma Quest
  Future<List<dynamic>> getReadBoard(int index, String tokenUser) async {
    var thread = await _boards[index].getRead(tokenUser);
    //O return estah aqui para evitar problemas com "thread.hasData" da FutureBuilder
    List<dynamic> list = new List<dynamic>();
    list.add(getBoardListCardsNames(index, tokenUser));
    list.add(getBoardListCardsStats(index, tokenUser));
    return list;
    //para contornar um dos problemas com threads foi utilizado esse return duplo para utilizacao na FutureBuilder
  }

  //Metodo que retorna a lista de Boards do TeamTrello
  List<Board> getListBoards(String tokenUser) {
    if (_boardsIsLoad) {
      return _boards;
    } else {
      _organizationBoards(tokenUser).then((str) {
        return _boards;
      });
    }
  }

  //Metodo que retorna a lista de nomes dos Cards de um Board do TrelloTeam
  List<String> getBoardListCardsNames(int index, String tokenUser) {
    return _boards[index].getListCardNames(tokenUser);
  }

  //Metodo que retorna a lista de IDs dos Cards de um Board do TrelloTeam
  List<String> getBoardListCardsIDs(int index, String tokenUser) {
    return _boards[index].getListCardIDs(tokenUser);
  }

  //Metodo que retorna um List<bool> de Stats dos Cards de um Board do TrelloTeam
  List<bool> getBoardListCardsStats(int index, String tokenUser) {
    return _boards[index].getListCardStats(tokenUser);
  }

  //Metodo que sera chamado no fim da configuraca de uma Board para Quest, esse metodo cria uma Board
  //Chamar esse metodo sem esperar o seu resultado
  Future<void> BoardToQuest(int index, List<int> goalHours, List<int> goalXp,
      int rewardItemId, int imgNumber, int xp, String tokenUser) async {
    if (_boardsIsLoad) {
      if (index < _boards.length) {
        var thread = await _boards[index].boardyAlreadyQuest();
        _boards[index].toQuest(this.name, goalHours, goalXp, rewardItemId, imgNumber, xp, tokenUser);
        _questIDsConfigured.add(_boards[index].id);
      }
    } else {
      var thread = await _organizationBoards(tokenUser);
      return BoardToQuest(index, goalHours, goalXp, rewardItemId, imgNumber, xp, tokenUser);
    }
  }

  //Metodo que verifica se um dado Board ja eh uma Quest
  bool boardyAlreadyQuest(int index, String tokenUser) {
    if(_boardsIsLoad) {
      if (_boards[index]._LoadCards) {
        return _boards[index].boardIsQuest;
      }
      else{
        _boards[index]._findAllCards(tokenUser).then((str){return _boards[index].boardIsQuest;});
      }
    }
    else{
      _organizationBoards(tokenUser).then((str){_boards[index]._findAllCards(tokenUser).then((str){return _boards[index].boardIsQuest;});});
    }
  }

  //Metodo que serah chamado no fim da pagina de configuracao de um TeamTrello para Guilda, esse metodo cria a Guilda
  configurateGuild(String description, User user, String guildImage) {
    if (_guildExists) {
      insertQuestInGuild(this.name, _questIDsConfigured);
    } else {
      if (_membersIsLoad) {
        insertGuild(this.name, description, user.name, guildImage, _membersID,
            _questIDsConfigured);
      } else {
        _getListMembers(user).then((str) {
          insertGuild(this.name, description, user.userName, guildImage, _membersID,
              _questIDsConfigured);
        });
      }
      user.addGuild(this.name);
      user.save();
    }
    _addListQuestInListUsers(_questIDsConfigured, _membersID);
    _questIDsConfigured = new List<String>();
  }
}

Future<void> _addListQuestInListUsers(
    List<String> questIDs, List<String> userNames) async {
  int i, j;
  for (i = 0; i < userNames.length; i++) {
    var firebase = (await Firestore.instance
        .collection('Users')
        .document(userNames[i])
        .get());
    if (firebase.exists) {
      var jsonUser = firebase.data;
      var quests = jsonUser['quest_id'].cast<String>();
      for (j = 0; j < questIDs.length; j++) {
        quests.add(questIDs[j]);
      }
      jsonUser['quest_id'] = quests;
      var thread = await Firestore.instance
          .collection('Users')
          .document(userNames[i])
          .setData(jsonUser);
    }
  }
}

Future<List<organizationTrello>> getListOrganizations(User user) async {
  String urlRequest = "https://api.trello.com/1/members/me/?key=" + APIKey + "&token=" + user.userKey;
  List<String> organizationIDs = (json.decode((await get(urlRequest)).body))['idOrganizations'].cast<String>();
  List<organizationTrello> list = new List<organizationTrello>();
  for (int i = 0; i < organizationIDs.length; i++) {
    list.add(new organizationTrello(organizationIDs[i], user));
  }
  await new Future.delayed(const Duration(seconds : 1));
  return list;
}