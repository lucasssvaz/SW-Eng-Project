import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart';
import 'package:job_adventure/models/TrelloBoard.dart';
import 'package:job_adventure/models/quest.dart';

final MyTrelloUtility = new TrelloUtility.basic();

class TrelloUtility{

  // Constantes
  // Por mais que você queira, elas nunca mudam

  final String APIKey = "57a893b02ea2046b82ac861766a34bed";

  // Variaveis a serem inicializadas

  String trelloKey;

  // Construtores

  TrelloUtility.basic();

  TrelloUtility(String trelloKey)
  {
    this.trelloKey = trelloKey;
  }

  // Vivemos em um mundo, belo e bonito,
  // onde tudo o que captas já está atualizado
  // (exceto se essa for sua primeira vez)

  Future <List<Quest>> InitialTrelloUtility(bool save) async
  {
    List<Quest> myQuests = [];

    // Recebe todos os Boards do Trello
    // E dados relevantes do Usuario

    dynamic UserData = await RequestBoards();
    List<dynamic> myBoards = UserData['idBoards'];

    // Converte cada Board em uma quest
    for(int i = 0; i < myBoards.length; i++)
    {
      // Requisita os Cards(goals) de cada Board
      dynamic Board = await RequestBoard(myBoards[i]);

      Quest UserQuest = Quest(
          id: myBoards[i], name: Board['name'], goal: [], goalID: [],
          goalStats: [], goalHours: [], goalXp: [], xp: 1, imgNumber: 1, rewardItemId: 1
      );

      //print("Teste 1: " + myBoards[i].toString() + " : " + Board['name']);

      dynamic card = Board['cards'];
      for(int  j = 0; j < card.length; j++)
      {
        UserQuest.goal.add(card[j]['name']);
        UserQuest.goalID.add(card[j]['id']);
        UserQuest.goalStats.add(card[j]['closed']);
        UserQuest.goalHours.add(1);
        UserQuest.goalXp.add(5);

        //print("Teste 2: " + card[j]['name'] + " : " + card[j]['id'] + " : " + card[j]['closed'].toString());
      }

      myQuests.add(UserQuest);

      if(save)
        UserQuest.save();
    }

    // Recupera todos as Quests do Banco

    //Compara todos os Boards com as Quests e da update ['idBoards']

    return myQuests;
  }

  // Requisição de todos os Boards
  // -----------------------------
  // Não seria interessante se você tivesse acesso
  // a todos os IdBoards do usuário.
  // Pois bem... Você tem!

  Future <dynamic> RequestBoards() async
  {
    final requisicao = await get("https://api.trello.com/1/members/me?key=" + APIKey + "&token=" + trelloKey);
    return json.decode(requisicao.body);
  }

  Future <dynamic> RequestBoardsByKey(String trelloKey) async
  {
    final requisicao = await get("https://api.trello.com/1/members/me?key=" + APIKey + "&token=" + trelloKey);
    return json.decode(requisicao.body);
  }

  // Requisição de Cards e Boards
  // ---------------------------
  // Me diga quem tu és, e perguntarei a Deus,
  // TRELLO!!! aquele que tudo sabe,
  // com quem vosmecê andas

  Future <dynamic> RequestCard(String card) async
  {
      final requisicao = await get("https://api.trello.com/1/card/"  + card +  "?key=" + APIKey + "&token=" + trelloKey);
      return json.decode(requisicao.body);
  }

  Future <dynamic> RequestCardByKey(String card, String trelloKey) async
  {
    final requisicao = await get("https://api.trello.com/1/card/"  + card +  "?key=" + APIKey + "&token=" + trelloKey);
    return json.decode(requisicao.body);
  }

  Future <dynamic> RequestBoard(String BoardId) async
  {
    // Os cards também vem junto. Adicionar ou remover elementos, se necessario
    final requisicao = await get("https://api.trello.com/1/boards/"  + BoardId +  "?cards=all&key=" + APIKey + "&token=" + trelloKey);
    return json.decode(requisicao.body);
  }

  Future <dynamic> RequestBoardByKey(String BoardId, String trelloKey) async
  {
    // Os cards também vem junto. Adicionar ou remover elementos, se necessario
    final requisicao = await get("https://api.trello.com/1/boards/"  + BoardId +  "?cards=all&key=" + APIKey + "&token=" + trelloKey);
    return json.decode(requisicao.body);
  }


  // Atualizações de Card e Board no Trello
  // --------------------------------------
  // Se você esta atualizando, você sabe o que deve ter ai...
  // Não precisa pegar nada de volta. Apenas vá embora!

  Future <void> UpdateCard(Quest UserQuest, int i) async
  {
    put("https://api.trello.com/1/cards/"  + UserQuest.goalID[i] + "?name=" + UserQuest.goal[i] + "&closed=" + UserQuest.goalStats[i].toString() + "&key=" + APIKey + "&token=" + trelloKey);
  }

  Future <void> UpdateCardByKey(Quest UserQuest, int i, String trelloKey) async
  {
    put("https://api.trello.com/1/cards/"  + UserQuest.goalID[i] + "?name=" + UserQuest.goal[i] + "&closed=" + UserQuest.goalStats[i].toString() + "&key=" + APIKey + "&token=" + trelloKey);
  }

  Future <void> UpdateBoard(Quest UserQuest) async
  {
    put("https://api.trello.com/1/boards/" + UserQuest.id + "?name=" + UserQuest.name + "&key=" + APIKey + "&token=" + trelloKey);
  }

  Future <void> UpdateBoardByKey(Quest UserQuest, String trelloKey) async
  {
    put("https://api.trello.com/1/boards/" + UserQuest.id + "?name=" + UserQuest.name + "&key=" + APIKey + "&token=" + trelloKey);
  }


  // Metodos de assistência
  // ----------------------
  // De vez enquando é bom facilitar sua vida
  // com pequenos procedimentos que podem aumentar
  // o nivel do programa para você


  void QuestSave(Quest UserQuest)
  {
    UserQuest.save();
    UpdateBoard(UserQuest);
  }

  void GoalSave(Quest UserQuest, int i)
  {
    UserQuest.save();
    UpdateCard(UserQuest, i);
  }



}

