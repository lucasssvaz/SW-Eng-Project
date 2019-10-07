import 'package:http/http.dart';
import 'dart:convert';
import 'package:job_adventure/models/quest.dart';

const String APIKey = "57a893b02ea2046b82ac861766a34bed";
/*
Future<void> initialBoardRoute(User user) async
{
  TrelloBoards UserBoards = new TrelloBoards(user.userKey);
  await UserBoards.FindAllBoards(user.userKey);
  for(int i =0; i < UserBoards.boards.length; i++)
  {
    Quest aux = UserBoards.boards[i].ToQuest();
    user.addQuest(aux.id);
    aux.save();
  }
  user.save();
}
*/
// Trello Boards ----------------------------------------------------------------------------------

class TrelloBoards
{
  List<TrelloBoard> boards = [];

  // Construtores -------------------------------------------------------------

  TrelloBoards(String trelloKey) // Constructor
  {

    //_FindAllBoards(trelloKey);
  }

  // Metodos Privados ---------------------------------------------------------

  FindAllBoards(String trelloKey) async
  {

    VectorString AllBoards = await _requestAllBoards("https://api.trello.com/1/members/me?boardStars=false&organization_paid_account=false&paid_account=false&savedSearches=false&key="+APIKey+"&token="+trelloKey);


    for(int i = 0; i < AllBoards.vector.length; i++)
    {
      TrelloBoard auxBoard = TrelloBoard.BasicToRquest(); // Create a Board by request (Import Trello Cards)
      await auxBoard.Build_ByIdRequest(AllBoards.vector[i], trelloKey);
      boards.add(auxBoard);

    }

  }

  Future<VectorString> _requestAllBoards (String url) async{
    final response = await get(url);
    var jsonresponse = json.decode(response.body);

    return VectorString(vector: jsonresponse['idBoards']);
  }

  // Utilidades ---------------------------------------------------------------


}

// Trello Board -----------------------------------------------------------------------------------

class TrelloBoard
{
  String id;
  String name;
  List<dynamic> cards;


  // Metodos Publicos ---------------------------------------------------------

  Quest ToQuest()
  {
    Quest UserQuest = Quest(
      id: this.id,
      name: this.name,
      goal: [],
      goalID: [],
      goalStats: [],
      goalHours: [],
      goalXp: [],
      xp: 1,
      imgNumber: 1,
      rewardItemId: 1
    );


    for(int  j = 0; j < cards.length; j++)
    {
      UserQuest.goal.add(this.cards[j]['name']);
      UserQuest.goalID.add(this.cards[j]['id']);
      UserQuest.goalStats.add(this.cards[j]['closed']);
      UserQuest.goalHours.add(1);
      UserQuest.goalXp.add(5);
    }
    return UserQuest;
  }

  // Construtores -------------------------------------------------------------

  TrelloBoard({this.id, this.name});

  TrelloBoard.BasicToRquest();

  TrelloBoard.ByQuest(Quest UserQuest)
  {
    // Usar metodo "ToBoard" da quest
    // para atribuir valor aos atributos
    // do Board atual
  }

  Build_ByIdRequest(String BoardId, String trelloKey) async
  {


    await _FindAllCardsInBoard(BoardId, trelloKey);

    this.id = BoardId;

    this.name = await _RequestTrelloName(BoardId, trelloKey);
  }

  // Metodos Privados ---------------------------------------------------------
  _RequestTrelloName(String BoardId, String trelloKey) async
  {
    String name = await _requestBoardName("https://api.trello.com/1/boards/"  + BoardId +  "?cards=all&key="+APIKey+"&token="+trelloKey);
    return name;
  }

  _FindAllCardsInBoard(String BoardId, String trelloKey) async
  {
    VectorString AllCards = await _requestCards("https://api.trello.com/1/boards/"  + BoardId +  "?cards=all&key="+APIKey+"&token="+trelloKey);
    this.cards = AllCards.vector;
  }

  Future<VectorString> _requestCards(String url) async {
    final response = await get(url);
    var jsonresponse = json.decode(response.body);

    return VectorString(vector: jsonresponse['cards']);
  }

  Future<String> _requestBoardName (String url) async{
    final response = await get(url);
    var jsonresponse = json.decode(response.body);
    String nome = jsonresponse['name'];
    return nome;
  }

  // Utilidades ---------------------------------------------------------------

  TrelloBoard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cards = json['cards'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cards'] = this.cards;
    return data;
  }
}

// Vector String ----------------------------------------------------------------------------------

class VectorString
{
  List<dynamic> vector;

  // Construtores -------------------------------------------------------------

  VectorString({this.vector});

  VectorString.fromJson(Map<String, dynamic> json) {
    vector = json['vector'].cast<String>();
  }

  // Utilidades ---------------------------------------------------------------

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vector'] = this.vector;
    return data;
  }
}

// Utilidades -------------------------------------------------------------------------------------



/*
Future<VectorString> requestAllBoards (String url) async{
  final response = await get(url);
  var jsonresponse = json.decode(response.body);

  return VectorString(vector: jsonresponse['idBoards']);
}

Future<VectorString> requestBoardName (String url) async{
  final response = await get(url);
  var jsonresponse = json.decode(response.body);

  return VectorString(vector: jsonresponse['name']);
}

Future<VectorString> requestCards(String url) async {
  final response = await get(url);
  var jsonresponse = json.decode(response.body);

  return VectorString(vector: jsonresponse['cards']);
}
*/
//initialQuest(String trelloKey) async{

//print("To AQ");
//print("ToAqui" + AllBoards.vector[0].toString() + APIKey.toString() + trelloKey.toString());

//Testar metodo de Salvamento e puxar boards e cards
/*
  TrelloBoard Board = await requestQuest("https://api.trello.com/1/members/me/?key="+APIKey+"&token="+trelloKey);

  Quest UserQuest = Quest(
    id: Board.id,
    name: Board.name,
    goal: Board.cards,
      goalStats: [false, false, true],
      goalHours: [4, 4, 4],
      goalXp: [95,100,5],
      rewardItemId: 5,
      xp: 150
  );
  print(UserQuest.name);
  UserQuest.save();
*/
/*for(int i = 0; i < AllBoards.vector.length; i++)
    {
      boards[i] = await requestQuest("https://api.trello.com/1/boards/"  + AllBoards.vector[i].toString() +  "?cards=all&key="+APIKey+"&token="+trelloKey);
      Quest UserQuest = Quest(
        id: boards[i].id,
        name: boards[i].name,
        goal: [],
        goalStats: [],
        goalHours: [],
        goalXp: [],
        rewardItemId: 5,
        xp: 150
      );
    for(int  j = 0; j < boards[i].cards.length; j++)
    {
     UserQuest.goal.add(boards[i].cards[i]['id']);
    }
    print(UserQuest.name);

    UserQuest.save(); // Se desejar que salve no banco
    }*/


