//Not yet develloped

import 'package:flutter/material.dart';
import 'package:job_adventure/Widgets/GuildWidgets.dart';

class GuildScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GuildScreen();
  }
}

class _GuildScreen extends State<GuildScreen> {
  @override
  Widget build(BuildContext context) {
    return (new Container(
      padding: const EdgeInsets.all(30.0),
      child: new GuildInfo()
    )
    );
  }
}
