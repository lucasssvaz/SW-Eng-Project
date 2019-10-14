import 'package:flutter/material.dart';
import 'package:job_adventure/Screens/NavigationMenu.dart';
import 'package:job_adventure/Screens/LoginScreen.dart';
import 'package:job_adventure/Screens/ProfileScreen.dart';
import 'package:job_adventure/Screens/QuestPage.dart';
import 'package:job_adventure/Screens/TrelloLoginScreen.dart';
import 'package:job_adventure/Screens/GuildScreen.dart';

void main() => runApp(MaterialApp(
  title: 'Job Adventure',
  initialRoute: 'loginScreen',
  debugShowCheckedModeBanner: false,
  routes:{
    'loginScreen': (context) => LoginScreen(),
    'NavigationMenu': (context) => NavigationMenu(),
    '/webview': (context) => TrelloLoginScreen(),
    'profilescreen': (context) => ProfileScreen(),
    'guildscreen': (context) => GuildScreen(),
    ExtractArgumentsScreen.routeName: (context) => new ExtractArgumentsScreen(),
  }
));
/*
{
    String APIKey = "57a893b02ea2046b82ac861766a34bed";
    String trelloKey = "3b7b3d9cae92dd09da1f04315ae95309a2ce10fbfe7f9bd002f0720ba2de44ec";


    TrelloBoards UserBoards = new TrelloBoards(trelloKey);
    await UserBoards.FindAllBoards(trelloKey);

    print("Até aqui funfa");

    for(int i =0; i < UserBoards.boards.length; i++)
    {
        Quest aux = UserBoards.boards[i].ToQuest();
        aux.save();
    }


    print("Convertido Board para Quest");



    print("algo novo");

}*/