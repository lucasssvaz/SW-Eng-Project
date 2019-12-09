import 'package:flutter/material.dart';
import 'package:job_adventure/models/TrelloOrganization.dart';
import 'package:job_adventure/models/user.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';



class TrelloTeamBoardToQuestArgs{
  User user;
  organizationTrello organization;
  int boardIndex;
  String boardName;
  TrelloTeamBoardToQuestArgs({this.user, this.organization, this.boardIndex, this.boardName});
}

class TrelloTeamBoardToQuest extends StatefulWidget {
  static const routeName = 'TrelloTeamBoardToQuest';

  @override
  _TrelloTeamBoardToQuestState createState() => _TrelloTeamBoardToQuestState();
}

class _TrelloTeamBoardToQuestState extends State<TrelloTeamBoardToQuest> {
  String questImagesPath = 'assets/images/';
  List<String> questImages = ['quest1.jpg', 'quest2.jpg', 'quest3.jpg', 'quest4.jpg', 'quest5.jpg'];
  int imgQuestNumber = 0;

  String itemsPath = 'assets/images/items/';
  List<String> items = ['SimpleStaff.png', 'MasterSword.png'];
  int imgItemNumber = 0;

  var goalHoursControllers;
  var goalXpControllers;
  var xpForm;

  _TrelloTeamBoardToQuestState(){
    goalHoursControllers = new List<TextEditingController>();
    goalXpControllers = new List<TextEditingController>();
    goalXpControllers = new List<TextEditingController>();
    xpForm = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final TrelloTeamBoardToQuestArgs args = ModalRoute.of(context).settings.arguments;
    final User user = args.user;
    final organizationTrello organization = args.organization;
    final int boardIndex = args.boardIndex;
    final String boardName = args.boardName;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(removeBoardTrelloPresets(boardName)),
      ),
      body: FutureBuilder(
        future: organization.getReadBoard(boardIndex, user.userKey),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> thread){
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
            final List<String> cardNames = thread.data[0];
            final List<bool> cardStats = thread.data[1];
            int i;
            for(i=goalXpControllers.length;i<cardNames.length;i++){
              goalXpControllers.add(TextEditingController());
              goalHoursControllers.add(TextEditingController());
            }
            return Container(
              child: ListView(
                children: <Widget>[
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: cardNames.length,
                      itemBuilder: (BuildContext context, int index) {
                        return cardViewPutInformations(context, cardNames, cardStats, goalHoursControllers, goalXpControllers, index, user);
                      }
                  ),

                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: xpForm,
                    style: TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20.0),
                      border: OutlineInputBorder(),
                      hintText: 'XP de término',

                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text('Selecione o item recompensa', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold))
                    ),
                  ),

                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index){
                      var color;
                      if(index==imgItemNumber){
                        color = Colors.green;
                      }
                      else{
                        color = Colors.white;
                      }
                      return Container(
                        child: FlatButton(
                            onPressed: (){
                              setState(() {
                                imgItemNumber = index;
                              });
                            }
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage(itemsPath+items[index]),
                            fit: BoxFit.scaleDown,
                          ),
                          borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                          border: new Border.all(
                            color: color,
                            width: 5.0,
                          ),
                        ),
                      );
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text('Selecione a imagem para a Quest', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold))
                    ),
                  ),

                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemCount: questImages.length,
                    itemBuilder: (BuildContext context, int index){
                      var color;
                      if(index==imgQuestNumber){
                        color = Colors.green;
                      }
                      else{
                        color = Colors.white;
                      }
                      return Container(
                        child: FlatButton(
                            onPressed: (){
                              setState(() {
                                imgQuestNumber = index;
                              });
                            }
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage(questImagesPath+questImages[index]),
                            fit: BoxFit.scaleDown,
                          ),
                          borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                          border: new Border.all(
                            color: color,
                            width: 5.0,
                          ),
                        ),
                      );
                    },
                  ),

                  FlatButton(
                      onPressed: () {
                        int i, xp;
                        List<int> goalHours = new List<int>();
                        List<int> goalXp = new List<int>();
                        for(i=0;i<goalHoursControllers.length;i++){
                          if(goalHoursControllers[i].text.toString().length>0)
                            goalHours.add(int.parse(goalHoursControllers[i].text));
                          else
                            goalHours.add(0);
                          if(goalXpControllers[i].text.toString().length>0)
                            goalXp.add(int.parse(goalXpControllers[i].text));
                          else
                            goalXp.add(0);
                          //print('Goal i='+(i+1).toString()+' Hours='+goalHoursControllers[i].text+' XP='+goalXpControllers[i].text);
                          if(xpForm.text.toString().length>0)
                            xp = int.parse(xpForm.text);
                          else
                            xp = 0;
                          organization.BoardToQuest(boardIndex, goalHours, goalXp, imgItemNumber, imgQuestNumber, xp, user.userKey);
                        }
                        Navigator.pop(context);
                      },
                      color: Colors.amberAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text("Criar Quest", style: TextStyle(color: Colors.white))
                  )
                ],
              ),
            );
          }
        }
      ),
    );
  }
}

Container cardViewPutInformations(BuildContext context, List<String> cardNames, List<bool> cardStats, List<TextEditingController> goalHoursControllers,
    List<TextEditingController> goalXpControllers, int index, User user){
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
                        child: Text(removeBoardTrelloPresets(cardNames[index]), style: TextStyle(color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.bold))
                    )
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.all(3.0),
                width: MediaQuery.of(context).size.width*0.15,
                height: MediaQuery.of(context).size.height*0.08,
                alignment: Alignment.center,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: goalHoursControllers[index],
                  style: TextStyle(fontSize: 12.0),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                    border: OutlineInputBorder(),
                    hintText: 'Horas',

                  ),
                ),
              ),


              Container(
                padding: EdgeInsets.all(3.0),
                width: MediaQuery.of(context).size.width*0.15,
                height: MediaQuery.of(context).size.height*0.08,
                alignment: Alignment.center,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: goalXpControllers[index],
                  style: TextStyle(fontSize: 12.0),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                    border: OutlineInputBorder(),
                    hintText: 'XP',

                  ),
                ),
              )
            ],
          ),
        ),
      )
  );
}

String removeBoardTrelloPresets(String title){
  return title.replaceAll('QuadroCompartilhado', '');
}
