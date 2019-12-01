import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_adventure/Widgets/GuildList.dart';
import 'package:job_adventure/Screens/TrelloTeams.dart';
import 'package:job_adventure/models/user.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:job_adventure/Widgets/GuildMemberList.dart';

class GuildPage extends StatefulWidget {
  @override
  _GuildPageState createState() => _GuildPageState();
}

class _GuildPageState extends State<GuildPage> {
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5.0),
          child: ButtonTheme(
            minWidth: MediaQuery.of(context).size.width*0.8,
            height: 40.0,
            child: FlatButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context,
                      TrelloTeams.routeName,
                      arguments: user
                  );
                },
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text("Configurar nova Guilda", style: TextStyle(color: Colors.white))
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Sua lista de Guildas: ', style: TextStyle(fontSize: 18.0, ),),
        ),
        Container(
          height: MediaQuery.of(context).size.height*0.80,
          child:  GuildList(),
        )
      ],
    );
  }
}

class GuildDetails extends StatelessWidget {
  static const routeName = 'GuildDetails';
  @override
  Widget build(BuildContext context) {
    final String guildName = ModalRoute.of(context).settings.arguments;
    var guildDatabase = Firestore.instance.collection('Guilds').document(guildName).get();
    return Scaffold(
      body: FutureBuilder(
        future: guildDatabase,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> doc){
          if(!doc.hasData){
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
            return Container(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width: 55.0,
                            height: 55.0,
                            child: CircleAvatar(
                                backgroundColor: Color.fromRGBO(255, 211, 109, 0.4),
                                foregroundColor: Color.fromRGBO(255, 211, 109, 0.4),
                                backgroundImage: AssetImage(doc.data['ImagePath'])
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 110.0,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(guildName, style: TextStyle(fontSize: 18.0),)
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Ranking da Guilda: ", style: TextStyle(fontSize: 18.0),),
                    )
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*0.5,
                    child: GuildMemberList(guildName: guildName),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Descrição da Guilda: ", style: TextStyle(fontSize: 18.0),),
                      )
                  ),
                  Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.15,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(doc.data['Description'])
                        ),
                      )
                    )
                  )
                ],
              )
            );
          }
        },
      ),
    );
  }
}

