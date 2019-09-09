import 'package:flutter/material.dart';

class User {
  int id;
  String name;
  String function;
  int level;
  String type;
  int employerId;

  User(
      {this.id,
        this.name,
        this.function,
        this.level,
        this.type,
        this.employerId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    function = json['function'];
    level = json['level'];
    type = json['type'];
    employerId = json['employer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['function'] = this.function;
    data['level'] = this.level;
    data['type'] = this.type;
    data['employer_id'] = this.employerId;
    return data;
  }
}