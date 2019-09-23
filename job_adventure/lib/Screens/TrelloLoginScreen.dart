import 'package:flutter/material.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

const String ACCEPT = 'https://trello.com/1/token/approve';
const String URL = "https://trello.com/1/authorize?expiration=never&name=Job+Adventure&scope=read%2Cwrite&response_type=token&key=57a893b02ea2046b82ac861766a34bed";

class TrelloLoginScreen extends StatefulWidget{

  TrelloLoginScreen({Key key}) : super(key: key);

  @override
  createState() => TrelloLoginScreenState();
}

class TrelloLoginScreenState extends State<TrelloLoginScreen>{
  WebViewController _controller;
  Timer timer;

  @override
  void initState(){
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 100),(Timer t) => checkAcceptUrl());
  }

  build(BuildContext context){
    Widget screen = Scaffold(
      appBar: AppBar(title: Text("Trello login")),
      body: WebView(
        initialUrl: URL,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: <JavascriptChannel>[keyChannel(context)].toSet(),
        onWebViewCreated: (WebViewController webViewController){
         _controller = webViewController; 
        }
      )
    );
    return screen;
  }

  JavascriptChannel keyChannel(BuildContext context){
    return JavascriptChannel(
      name: "Print",
      onMessageReceived: (JavascriptMessage message){
        String _trelloKey = message.message; // Trello key is being held here, do the DB operations inside this function
        timer.cancel();
        Navigator.pushNamed(
          context,
          'NavigationMenu',
          arguments: _trelloKey
        );
      }
    );
  }

  void checkAcceptUrl() async{
    String currentURL = await _controller.currentUrl();
    if(currentURL == ACCEPT){
      _controller.evaluateJavascript("var x = document.getElementsByTagName('pre')[0].innerHTML; Print.postMessage(x);");
    }
  }
}