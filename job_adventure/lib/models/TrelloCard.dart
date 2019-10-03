
class TrelloCard {
  String id;
  String idBoard;
  String name;
  String idList;

  TrelloCard({this.id, this.idBoard, this.name, this.idList});

  /*
  TrelloCard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idBoard = json['idBoard'];
    pos = json['pos'];
    name = json['name'];
    idList = json['idList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idBoard'] = this.idBoard;
    data['pos'] = this.pos;
    data['name'] = this.name;
    data['idList'] = this.idList;
    return data;
  }
  */
}
