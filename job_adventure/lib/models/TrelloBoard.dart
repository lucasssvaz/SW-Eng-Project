import 'package:http/http.dart';
import 'dart:convert';
import 'package:job_adventure/models/quest.dart';

const String APIKey = "57a893b02ea2046b82ac861766a34bed";


class TrelloBoard {
  String id;
  String name;
  List<String> cards;

  TrelloBoard({this.id, this.name, this.cards});

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

Future<TrelloBoard> requestQuest(String url) async{
  final response = await get(url);

  var jsonresponse = json.decode(response.body);

  return await TrelloBoard(
      id: jsonresponse['id'],
      cards: jsonresponse['cards'],
      name: jsonresponse['name'],
  );
}


class VectorString {
  List<dynamic> vector;

  VectorString({this.vector});

  VectorString.fromJson(Map<String, dynamic> json) {
    vector = json['vector'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vector'] = this.vector;
    return data;
  }
}

Future<VectorString> requestBoards (String url) async{
  final response = await get(url);
  var jsonresponse = json.decode(response.body);

  return await VectorString(vector: jsonresponse['idBoards']);
}

initialQuest(String trelloKey) async{
  VectorString AllBoards = await requestBoards("https://api.trello.com/1/members/me?boardStars=false&organization_paid_account=false&paid_account=false&savedSearches=false&key="+APIKey+"&token="+trelloKey);
  print("To AQ");
  print("ToAqui" + AllBoards.vector[0].toString() + APIKey.toString() + trelloKey.toString());

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
}