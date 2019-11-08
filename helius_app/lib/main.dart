import 'package:flutter/material.dart';
import 'package:helius_app/services/authentication.dart';
import 'package:helius_app/pages/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helius',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new RootPage(auth: new Auth()));
  }
}


