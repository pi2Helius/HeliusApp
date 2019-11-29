import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SettingsScreenPage();
}

class _SettingsScreenPage extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        Icon(Icons.settings),
      ],
    );
  }

}