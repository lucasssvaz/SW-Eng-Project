import 'package:flutter/material.dart';
import 'package:job_adventure/models/guild.dart';
import 'package:job_adventure/models/TrelloOrganization.dart';

import 'package:job_adventure/models/user.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';

class TrelloTeamToGuildArgs{
  organizationTrello organization;
  User user;
  TrelloTeamToGuildArgs({this.user, this.organization});
}

class TrelloTeamToGuild extends StatefulWidget {
  static const routeName = 'TrelloTeamToGuild';

  @override
  _TrelloTeamToGuildState createState() => _TrelloTeamToGuildState();
}

class _TrelloTeamToGuildState extends State<TrelloTeamToGuild> {
  @override
  Widget build(BuildContext context) {
    final TrelloTeamToGuildArgs args = ModalRoute.of(context).settings.arguments;
    final organizationTrello organization = args.organization;
    final User user = args.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(organization.name),
        backgroundColor: Color.fromRGBO(255, 211, 109, 0.4)
      ),
      body: FutureBuilder(
        future: organization.getRead(user),
        builder: (BuildContext context, AsyncSnapshot thread){
          if(thread.connectionState==ConnectionState.waiting){
            return Center(
                child: Container(
                  color: Color.fromRGBO(255, 211, 109, 0.4),
                  child: Center(
                    child: Loading(indicator: BallSpinFadeLoaderIndicator(), size: 50.0),
                  ),
                )
            );
          }
          else{
            print("Carregamento terminado");
            print('Is guild Master? '+organization.isGuildMaster.toString());
            if(organization.isGuildMaster) {
              //Aqui sera mostrado a lista de Boards de uma TrelloOrganization e para cada Board serah possivel configurar uma nova Quest
              final List<Board> listboards = organization.getListBoards(
                  user.userKey);
              final guildDescription = TextEditingController();
              String guildImage;
              String descripton;
              int imgNumber;
              return Container(
                child: Row(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: FlatButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context,
                                  TrelloTeamToGuildMembers.routeName,
                                  arguments: TrelloTeamToGuildArgs(
                                      user: user, organization: organization)
                              );
                            },
                            color: Colors.amberAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text(
                                "Members", style: TextStyle(color: Colors.white))
                        )
                    ),
                    ListView.builder(
                        itemCount: listboards.length,
                        itemBuilder: (BuildContext context, int index) {
                          return boardViewFunction(
                              context, listboards, index, user);
                        }
                    ),
                    TextField(
                      controller: guildDescription, //a descricao da Guilda esta em guildDescription.text
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                        child: FlatButton(
                            onPressed: (){
                              Navigator.pushNamed(
                                  context,
                                  TrelloTeamToGuildImage.routeName,
                                  arguments: guildImage
                              );
                            },
                            color: Colors.amberAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text("Select Guild image",
                                style: TextStyle(color: Colors.white))
                        )
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: FlatButton(
                            onPressed: () {
                              descripton = guildDescription.text;
                              organization.configurateGuild(descripton, user, guildImage);
                              Navigator.pop(context);
                            },
                            color: Colors.amberAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Text("Done changes",
                                style: TextStyle(color: Colors.white))
                        )
                    )
                  ],
                ),
              );
            }
            else{
              return Container(
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Voce nao eh admin desse Team no Trello', style: TextStyle(fontSize: 18.0))
                    )
                  ],
                ),
              );
            }
          }
        },
      )
    );
  }
}

class TrelloTeamToGuildImage extends StatefulWidget {
  static const routeName = 'TrelloTeamToGuildImage';
  @override
  _TrelloTeamToGuildImageState createState() => _TrelloTeamToGuildImageState();
}

class _TrelloTeamToGuildImageState extends State<TrelloTeamToGuildImage> {
  @override
  Widget build(BuildContext context) {
    final ImagesPath = "/home/leon/Documentos/Unifesp/6 semestre/EngSoft/SW-Eng-Project/job_adventure/assets/images/GuildIcons";
    final List<String> images = ["business-guild-shield.png", "guild1.png", "guild2.png", "guild3.jpg", "guild4.png", "Stark-icon.png"];
    String guildImage = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecione a imagem para a Guilda"),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            GridView.count(
              crossAxisCount: 3,
              children: List.generate(images.length, (index){
                return GestureDetector(
                  onTap: (){
                    guildImage = ImagesPath + images[index];
                  },
                  child: Image.asset(ImagesPath+images[index]),
                );
              }),
            ),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.amberAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text("Imagem selecionada",
                        style: TextStyle(color: Colors.white))
                )
            )
          ],
        ),
      ),
    );
  }
}


class TrelloTeamToGuildMembersArgs{
  User user;
  organizationTrello organization;
  TrelloTeamToGuildMembersArgs({this.user, this.organization});
}

class TrelloTeamToGuildMembers extends StatelessWidget {
  static const routeName = 'ListMembersGuild';
  @override
  Widget build(BuildContext context) {
    TrelloTeamToGuildArgs args = ModalRoute.of(context).settings.arguments;
    organizationTrello organization = args.organization;
    List<String> members = organization.getListMembers(args.user);
    return Scaffold(
      appBar: AppBar(
        title: Text(organization.name + '- Members'),
        backgroundColor: Color.fromRGBO(255, 211, 109, 0.4),
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(members[index], style: TextStyle(fontSize: 15.0),)
                  )
                ],
              ),
            )
          );
        }
      ),
    );
  }
}



Container boardViewFunction(context, List<Board> boards, int index, User user){
  double c_width = MediaQuery.of(context).size.width*0.4;
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    child: Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              width: c_width,
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(boards[index].name, style: TextStyle(color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.bold))
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: FlatButton(
                  onPressed: (){
                    /*LUIZ COLOCAR AQUI A SUA CHAMADA DE PAGINA, ACREDITO QUE PRECISARA DE ARGUMENTOS*/
                    /*Navigator.pushNamed(
                        context,
                        TrelloBoardToQuest.routeName,
                        arguments: TrelloBoardToQuestArgs()
                    );*/
                  },
                  color: Colors.amberAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text("Configure", style: TextStyle(color: Colors.white))
              ),
            ),
          ],
        ),
      )
    ),
  );
}
