import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:job_adventure/models/guild.dart';
import 'package:job_adventure/models/TrelloOrganization.dart';

import 'package:job_adventure/models/user.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:job_adventure/Screens/TrelloTeamBoardToQuest.dart';

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
  List<String> members;
  final _ImagesPath = "assets/images/GuildIcons/";
  final List<String> _images = ["business-guild-shield.png", "guild1.png", "guild2.png", "guild3.jpg", "guild4.png", "Stark-icon.png"];

  void _showPopUpListMembers() {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Lista de membros'),
          content: Container(
            width: MediaQuery.of(context).size.width*0.60,
            height: MediaQuery.of(context).size.width*0.60,
            child: ListView(
              padding: EdgeInsets.all(8.0),
              //map List of our data to the ListView
              children: members.map((data) => Text('- '+data)).toList(),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final myController = TextEditingController();
  int imgNumber = 0;

  @override
  Widget build(BuildContext context) {
    final TrelloTeamToGuildArgs args = ModalRoute.of(context).settings.arguments;
    final organizationTrello organization = args.organization;
    final User user = args.user;
    return Scaffold(
      appBar: AppBar(
        title: Text(organization.name),
        backgroundColor: Color.fromRGBO(64, 115, 235, 92)
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: organization.getRead(user),
        builder: (BuildContext context, AsyncSnapshot<bool> thread){
          if(!thread.hasData){
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
            if(thread.data==true) {
              //Aqui sera mostrado a lista de Boards de uma TrelloOrganization e para cada Board serah possivel configurar uma nova Quest
              final List<Board> listboards = organization.getListBoards(
                  user.userKey);
              final guildDescription = TextEditingController();
              members = organization.getListMembersNames(args.user);
              String descripton;
              return Container(
                  child:
                  ListView(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          child: ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width*0.85,
                            height: 40.0,
                            child: FlatButton(
                                onPressed: () {
                                  _showPopUpListMembers();
                                },
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text("Lista de membros", style: TextStyle(color: Colors.white))
                            ),
                          )
                      ),

                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: listboards.length,
                          itemBuilder: (BuildContext context, int index) {
                            return boardViewWidget(context, listboards, index, user, organization);
                          }
                      ),

                      Padding(
                        padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
                        child: TextFormField(
                          autofocus: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Entre com a descrição da Guilda'
                          ),
                          controller: myController,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text('Selecione a imagem para a Guilda', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold))
                        ),
                      ),

                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        itemCount: _images.length,
                        itemBuilder: (BuildContext context, int index){
                          var color;
                          if(index==imgNumber){
                            color = Colors.green;
                          }
                          else{
                            color = Colors.white;
                          }
                          return Container(
                            child: FlatButton(
                                onPressed: (){
                                  setState(() {
                                    imgNumber = index;
                                  });
                                }
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                image: AssetImage(_ImagesPath+_images[index]),
                                fit: BoxFit.scaleDown,
                              ),
                              borderRadius: new BorderRadius.all(new Radius.circular(13.0)),
                              border: new Border.all(
                                color: color,
                                width: 5.0,
                              ),
                            ),
                          );
                        },
                      ),

                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                          child: FlatButton(
                              onPressed: () {
                                print(myController.text);
                                organization.configurateGuild(myController.text.toString(), user, _ImagesPath+_images[imgNumber]);
                                Navigator.pop(context);
                              },
                              color: Colors.amberAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text("Aplicar as configurações", style: TextStyle(color: Colors.white))
                          )
                      ),
                    ],
                  )
              );
            }

            else{
              return Container(
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Voce não é admin desse Team no Trello', style: TextStyle(fontSize: 18.0))
                    )
                  ],
                ),
              );
            }

          }
        },
      ),
    );
  }
}

String removeBoardTrelloPresets(String title){
  return title.replaceAll('QuadroCompartilhado', '');
}

Container boardViewWidget(context, List<Board> boards, int index, User user, organizationTrello organization){
  double c_width = MediaQuery.of(context).size.width*0.60;
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
              padding: EdgeInsets.all(12.0),
              width: c_width,
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(removeBoardTrelloPresets(boards[index].name), style: TextStyle(color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.bold))
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: FlatButton(
                  onPressed: (){
                    Navigator.of(context).pushNamed(
                        TrelloTeamBoardToQuest.routeName,
                        arguments: TrelloTeamBoardToQuestArgs(
                          user: user,
                          organization: organization,
                          boardIndex: index,
                          boardName: boards[index].name
                        )
                    );
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
