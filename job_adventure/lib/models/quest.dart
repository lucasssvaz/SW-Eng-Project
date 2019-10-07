<<<<<<<<< Temporary merge branch 1
import 'package:cloud_firestore/cloud_firestore.dart';

class Quest {
=========
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_adventure/models/user.dart';

class Quest {
  Timer _timer;
>>>>>>>>> Temporary merge branch 2
  String id;
  String name;
  List<String> goal;
  List<bool> goalStats;
  List<int> goalHours;
  List<int> goalXp;
  int rewardItemId;
  int xp;

  Quest({
    this.id,
    this.name,
    this.goal,
    this.goalStats,
    this.goalHours,
    this.goalXp,
    this.rewardItemId,
    this.xp});

  Quest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    goal = json['goal'].cast<String>();
    goalStats = json['goal_stats'].cast<bool>();
    goalHours = json['goal_hours'].cast<int>();
    goalXp = json['goal_xp'].cast<int>();
    rewardItemId = json['reward_item_id'];
    xp = json['xp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['goal'] = this.goal;
    data['goal_stats'] = this.goalStats;
    data['goal_hours'] = this.goalHours;
    data['goal_xp'] = this.goalXp;
    data['reward_item_id'] = this.rewardItemId;
    data['xp'] = this.xp;
    return data;
  }

  save(){
    Firestore.instance.collection('Quests').document(this.id).setData(toJson());
  }
}