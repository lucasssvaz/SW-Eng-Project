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

class TrelloTeamToGuild extends StatelessWidget {
  static const routeName = 'TrelloTeamToGuild';
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
        builder: (BuildContext context, AsyncSnapshot<void> thread){
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
            //Aqui sera mostrado a lista de Boards de uma TrelloOrganization e para cada Board serah possivel configurar uma nova Quest
            final List<Board> listboards = organization.getListBoards(user.userKey);
            final guildDescription = TextEditingController();
            String descripton;
            int imgNumber;
            return Row(
              children: <Widget>[
                ListView.builder(
                  itemCount: listboards.length,
                  itemBuilder: (BuildContext context, int index){
                    return boardViewFunction(context, listboards, index, user);
                  }
                ),
                TextField(
                  controller: guildDescription,//a descricao da Guilda esta em guildDescription.text
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: FlatButton(
                    onPressed: (){
                      descripton = guildDescription.text;
                    },
                    color: Colors.amberAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text("Done changes", style: TextStyle(color: Colors.white))
                  )
                )
              ],
            );
          }
        },
      )
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
