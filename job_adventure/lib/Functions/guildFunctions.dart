import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_adventure/models/quest.dart';

// Uso: insertGuild(nome da guilda, descricao, ID do guild master, path da imagem, Lista dos IDs dos membros)

void insertGuild(String guildName, String guildDescription, String guildMasterID, String guildImage, List<String> membersID, List<String> questIDs){
  Firestore.instance.collection('Guilds').document(guildName).setData({'Description': guildDescription,'GuildMasterID':guildMasterID,'Name':guildName,'ImagePath':guildImage, 'Quests': questIDs});
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


void insertQuestInGuild(String guildName, List<String> questIDs){
  Firestore.instance.collection('Guilds').document(guildName).get().then((DocumentSnapshot doc){
    var jsonresponse = doc.data;
    List<String> quests = jsonresponse['Quests'].cast<Quest>();
    int i;
    for(i=0;i<questIDs.length;i++){
      quests.add(questIDs[i]);
    }
    jsonresponse['Quests'] = quests;
    Firestore.instance.collection('Guilds').document(guildName).setData(jsonresponse);
  });
}


//Classe que sera retornada como lista em getGuildRank
class rankGuildObj{
  String userName;
  int xp;
  rankGuildObj({this.userName, this.xp});
}

Future<List<rankGuildObj>> getGuildRank(String guildName) async{
  var response = (await Firestore.instance.document('Guilds').collection(guildName).document('Members').get()).data;
  List<rankGuildObj> list = new List<rankGuildObj>();
  String userName;
  for(userName in response.keys){
    var xpRequest = (await Firestore.instance.collection('Guilds').document(guildName).collection('Members').document(userName).get()).data;
    list.add(new rankGuildObj(
        userName: userName,
        xp: xpRequest['memberXP']
    ));
  }
  mergeSortRank(list, 0, list.length-1);
  return list;
}

void mergeSortRank_concatena(List<rankGuildObj> list, int p, int q, int r){
  int i1=0;
  int i2=q+1-p;
  int j=p;
  List<rankGuildObj> aux = new List<rankGuildObj>();
  for(int i=0;i<=(r-q);i++){
    aux.add(list[p+i]);
  }
  while((j!=r)){
    if((i1<q+1-p)&&(i2<=r-p)){
      if(aux[i1].xp>=aux[i2].xp){
        list[j] = aux[i1];
        i1++;
      }
      else{
        list[j] = aux[i2];
        i2++;
      }
    }
    else if(i1<q+1-p){
      list[j] = aux[i1];
      i1++;
    }
    else{
      list[j] = aux[i2];
      i2++;
    }
    j++;
  }
}

void mergeSortRank(List<rankGuildObj> list, int p, int r){
  if(p!=r){
    int q = ((r-p)/2).floor();
    mergeSortRank(list, p, q);
    mergeSortRank(list, q+1, r);
    mergeSortRank_concatena(list, p, q, r);
  }
}