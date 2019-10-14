//All the widgets used in the Guild screen

import 'package:flutter/material.dart';

class GuildInfo extends StatefulWidget {
  final state = new _GuildInfo();

  @override
  _GuildInfo createState() => state;
}

/*IMPORTANTE, PEGAR AS INFORMAÇÕES DA GUILDA DO DB OU DO TRELLO E PASSAR AQUI*/

class _GuildInfo extends State<GuildInfo> {
  String guild_name = 'Name';

  int guild_lv = 0;

  int guild_xp = 0;

  //Construtor para a criação do Widget ja com as informações corretas
  //Deve ser chamado na GuildScreen ja com os valore do DB
  //_GuildInfo(this.name, this.guild_lv, this.guild_xp);

  @override
  Widget build(BuildContext context) {
    return (new Container(
        child: new Column(
      children: <Widget>[
        //Cria a imagem da guilda
        _getGuildLogo(),
        _getGuildCustomName(),
        // _getGuildLevelBar()
      ],
    )));
  }

//Returns the GuildShield according to the guild level
  Widget _getGuildLogo() {
    //Setar os caminhos de acordo com cada uma das imagens escolhidas
    String img_path() {
      if ((guild_lv >= 0) && (guild_lv <= 10)) return ('assets/images/guild/GuildEmblem1.jpg');
      if ((guild_lv > 10) && (guild_lv <= 20)) return ('path2');
      if ((guild_lv > 20) && (guild_lv <= 30)) return ('path3');
      if ((guild_lv > 30) && (guild_lv <= 40)) return ('path4');
      if ((guild_lv > 40) && (guild_lv <= 50)) return ('path5');
      if ((guild_lv > 50) && (guild_lv <= 60)) return ('path6');
      if ((guild_lv > 60) && (guild_lv <= 70)) return ('path7');
      if ((guild_lv > 70) && (guild_lv <= 80)) return ('path8');
      if ((guild_lv > 80) && (guild_lv <= 90)) return ('path9');
      if ((guild_lv > 90) && (guild_lv <= 100)) return ('path10');
      if ((guild_lv > 100)) return ('path11');
    }

    return (new Image.asset(
      img_path(),
      scale: 2.0,
    ));
  }

  //Returns the guild name customized
  Widget _getGuildCustomName() {
    //3 different banners available for the guild levels
    String banner_path() {
      if ((guild_lv >= 0) && (guild_lv <= 50)) return ('assets/images/guild/banner.png');
      if ((guild_lv > 50) && (guild_lv <= 100)) return ('path2');
      if (guild_lv > 100) return ('path3');
    }

    return (new Stack(
      fit: StackFit.loose,
      children: <Widget>[
        new Container(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: RichText(
              text: TextSpan(
                text: guild_name,
                style: DefaultTextStyle.of(context).style,
              )
            )
          )
        ),
        new Image.asset(
          banner_path(),
          scale: 2.0,
        )
      ],
    ));
  }

  //Returns the animated level bar
  Widget _getGuildLevelBar() {}
}
