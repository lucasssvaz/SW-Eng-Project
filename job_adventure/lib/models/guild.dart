class Guild {
  int id;
  String name;
  String description;
  int guildMasterId;

  Guild({this.id, this.name, this.description, this.guildMasterId});

  Guild.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['Description'];
    guildMasterId = json['guild_master_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['Description'] = this.description;
    data['guild_master_id'] = this.guildMasterId;
    return data;
  }
}