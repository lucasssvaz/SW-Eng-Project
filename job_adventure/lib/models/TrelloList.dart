class TrelloList {
  String id;
  String name;
  bool closed;
  String idBoard;
  int pos;
  bool subscribed;

  TrelloList(
      {this.id,
        this.name,
        this.closed,
        this.idBoard,
        this.pos,
        this.subscribed});

  TrelloList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    closed = json['closed'];
    idBoard = json['idBoard'];
    pos = json['pos'];
    subscribed = json['subscribed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['closed'] = this.closed;
    data['idBoard'] = this.idBoard;
    data['pos'] = this.pos;
    data['subscribed'] = this.subscribed;
    return data;
  }
}