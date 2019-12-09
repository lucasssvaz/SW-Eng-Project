import 'package:flutter/material.dart';

import 'package:job_adventure/models/TrelloOrganization.dart';
import 'package:job_adventure/models/user.dart';
import 'package:job_adventure/Screens/TrelloTeamToGuild.dart';

import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';


class TrelloTeams extends StatefulWidget {
  static const routeName = 'TrelloTeams';
  @override
  _TrelloTeamsState createState() => _TrelloTeamsState();
}

class _TrelloTeamsState extends State<TrelloTeams> {
  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Seus times no Trello'),
      ),
      body: FutureBuilder(
        future: getListOrganizations(user),
        builder: (BuildContext context, AsyncSnapshot<List<organizationTrello>> thread){
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
            List<organizationTrello> organizations = thread.data;
            //print('Quantidade de team Boards '+organizations.length.toString());
            return Container(
              child: ListView.builder(
                itemCount: organizations.length,
                itemBuilder: (BuildContext context, int index) {
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
                                width: MediaQuery.of(context).size.width*0.60,
                                child: Column(
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(removeBoardTrelloPresets(organizations[index].name), style: TextStyle(color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.bold))
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
                                          TrelloTeamToGuild.routeName,
                                          arguments: TrelloTeamToGuildArgs(
                                            organization: organizations[index],
                                            user: user
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
                          ]
                        ),
                      )
                    ),
                  );
                },
              ),
            );
          }
        }
      ),
    );
  }
}

String removeBoardTrelloPresets(String title){
  return title.replaceAll('QuadroCompartilhado', '');
}
