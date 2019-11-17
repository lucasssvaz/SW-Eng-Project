import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_adventure/Screens/NavigationMenu.dart';
import 'package:job_adventure/Screens/LoginScreen.dart';
import 'package:job_adventure/Screens/ProfileScreen.dart';
import 'package:job_adventure/Screens/QuestPage.dart';
import 'package:job_adventure/Screens/TrelloLoginScreen.dart';
import 'package:job_adventure/models/TrelloUtility.dart';
import 'package:job_adventure/models/quest.dart';
import 'package:job_adventure/Screens/TrelloTeamToGuild.dart';
import 'package:job_adventure/Screens/TrelloTeamBoardToQuest.dart';

void main()=> runApp(MaterialApp(
  title: 'Job Adventure',
  initialRoute: 'loginScreen',
  debugShowCheckedModeBanner: false,
  routes:{
    'loginScreen': (context) => LoginScreen(),
    'NavigationMenu': (context) => NavigationMenu(),
    '/webview': (context) => TrelloLoginScreen(),
    'profilescreen': (context) => ProfileScreen(),
    ExtractArgumentsScreen.routeName: (context) => ExtractArgumentsScreen(),
    TrelloTeamToGuild.routeName: (context) => TrelloTeamToGuild(),
    TrelloTeamBoardToQuest.routeName: (context) => TrelloTeamBoardToQuest(),
  }
));

/*
{
    String APIKey = "57a893b02ea2046b82ac861766a34bed";
    String trelloKey = "3b7b3d9cae92dd09da1f04315ae95309a2ce10fbfe7f9bd002f0720ba2de44ec";

    TrelloUtility myUtility = new TrelloUtility(trelloKey);
    //List<Quest> AllQuests = await myUtility.InitialTrelloUtility(true);

    Quest myQuest = new Quest.toLoad();
    await myQuest.load("5da4c6c97c88da165442504b");
    //print("Teste 4 : " + myQuest.goal.toString());
    myQuest.goal[0] = "Achar os TeamBoards";
    myUtility.GoalSave(myQuest,0);

    myQuest.goal[0] = "Interligação com o Banco de Dados";
    myQuest.name = "Eng de Software";
    myUtility.UpdateCard(myQuest, 0);
    myUtility.UpdateBoard(myQuest);

    print("algo novo");

}*/