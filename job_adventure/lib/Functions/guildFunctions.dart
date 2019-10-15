import 'package:cloud_firestore/cloud_firestore.dart';

void insertGuild(String guildName, String guildDescription, String guildMasterID, String guildImage, List<String> membersID){
  Firestore.instance.collection('Guilds').document(guildName).setData({'Description': guildDescription,'GuildMasterID':guildMasterID,'Name':guildName,'ImagePath':guildImage});
  membersID.forEach((f){
    Firestore.instance.collection('Users').document(f).get().then((DocumentSnapshot ds){
      dynamic memberNameMessage = ds['name'];
      String memberName = memberNameMessage != null? memberNameMessage.toString() : '<No message retrieved>';  
      Firestore.instance.collection('Guilds').document(guildName).collection('Members').document(f).setData({'Name':memberName}); // Colocar depois a imagem aqui tambem
      Firestore.instance.collection('Users').document(f).collection('Guilds').document(guildName).setData({'Guild_ID':guildName,'ImagePath':guildImage});
    });
  });
}

void removeGuild(String guildName) async{
  Firestore.instance.collection('Guilds').document(guildName).collection('Members').snapshots().listen((snapshot){
    snapshot.documents.forEach((f) async{
      String userName = f.documentID;
      print(userName);
      await Firestore.instance.runTransaction((Transaction myTransaction) async{
        myTransaction.delete(Firestore.instance.collection('Users').document(userName).collection('Guilds').document(guildName));
      });
      await Firestore.instance.runTransaction((Transaction myTransaction) async{
        myTransaction.delete(f.reference);
      });
      print('aaa');
    });
  });
  await Firestore.instance.runTransaction((Transaction myTransaction) async{
    myTransaction.delete(Firestore.instance.collection('Guilds').document(guildName));
  });
}
