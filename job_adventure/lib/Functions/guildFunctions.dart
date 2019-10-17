import 'package:cloud_firestore/cloud_firestore.dart';

// Uso: insertGuild(nome da guilda, descricao, ID do guild master, path da imagem, Lista dos IDs dos membros)

void insertGuild(String guildName, String guildDescription, String guildMasterID, String guildImage, List<String> membersID){
  Firestore.instance.collection('Guilds').document(guildName).setData({'Description': guildDescription,'GuildMasterID':guildMasterID,'Name':guildName,'ImagePath':guildImage});
  membersID.forEach((f){
    Firestore.instance.collection('Users').document(f).get().then((DocumentSnapshot ds){
      dynamic memberNameMessage = ds['name'];
      String memberName = memberNameMessage != null? memberNameMessage.toString() : '<No message retrieved>';  
      Firestore.instance.collection('Guilds').document(guildName).collection('Members').document(f).setData({'Name':memberName, 'memberXP': 0}); // Colocar depois a imagem aqui tambem
      Firestore.instance.collection('Users').document(f).collection('Guilds').document(guildName).setData({'Guild_ID':guildName,'ImagePath':guildImage});
    });
  });
}

// Uso: removeGuild(Nome da guilda)

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
    });
  });
  await Firestore.instance.runTransaction((Transaction myTransaction) async{
    myTransaction.delete(Firestore.instance.collection('Guilds').document(guildName));
  });
}

// Uso: insertMember(nome da guilda, ID do usuario)

void insertMember(String guildName, String userID){
  Firestore.instance.collection('Users').document(userID).get().then((DocumentSnapshot ds){
    dynamic nameMessage = ds['Name'];
    String name = nameMessage != null ? nameMessage.toString() : '<null>';
    Firestore.instance.collection('Guilds').document(guildName).collection('Members').document(userID).setData({'Name': name, 'memberXP': 0});
  });
  Firestore.instance.collection('Guilds').document(guildName).get().then((DocumentSnapshot ds){
    dynamic nameMessage = ds['Name'];
    String name = nameMessage != null ? nameMessage.toString() : '<null>';
    dynamic imageMessage = ds['ImagePath'];
    String image = imageMessage != null ? imageMessage.toString() : '<null>';
    Firestore.instance.collection('Users').document(userID).collection('Guilds').document(guildName).setData({'Guild_ID': name, 'ImagePath': image});
  });
}

//Uso: removeMember(nome da guilda, ID do usuario)

void removeMember(String guildName, String userID){
  Firestore.instance.runTransaction((Transaction myTransaction) async{
    await myTransaction.delete(Firestore.instance.collection('Guilds').document(guildName).collection('Members').document(userID));
    await myTransaction.delete(Firestore.instance.collection('Users').document(userID).collection('Guilds').document(guildName));
  });
}

// Uso: increaseGuildMemberXP(nome da guilda, ID do usuario, valor de xp a ser ganho)

void increaseGuildMemberXP(String guildName, String userID, int xpAmount){
  final DocumentReference ref = Firestore.instance.collection('Guilds').document(guildName).collection('Members').document(userID);
  Firestore.instance.runTransaction((Transaction myTransction) async{
    DocumentSnapshot snapshot = await myTransction.get(ref);
    if(snapshot.exists){
      await myTransction.update(ref, {'memberXP': snapshot.data['memberXP'] + xpAmount});
    }
  });
}
