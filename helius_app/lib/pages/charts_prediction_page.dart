import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:helius_app/components/chart_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PredictionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PredictionScreenPage();
}

class _PredictionScreenPage extends State<PredictionScreen> {
  // Variables

  ChartCard cardMaker = ChartCard();



  @override
  Widget build(BuildContext context) {
    
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        _showAtualPowStatusCard(),
        _showPowHourRow(),
        _showWeekPow(),
      ],
    );
  }

  Widget _showAtualPowStatusCard(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      height: 120.0,
      child: cardMaker.card(FlutterLogo(colors: Colors.red)),
    );
  }

  Widget _showPowHourRow(){
    final double cardHeight = 100.0;
    final double cardWidth = 80.0;
    final double cardMarginH = 10.0;
    final double cardMarginV = 10.0;

    return Container(
      height: cardHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: cardMarginH, vertical: cardMarginV),
            width: cardWidth,
            child: cardMaker.card(FlutterLogo(colors: Colors.red)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: cardMarginH, vertical: cardMarginV),
            width: cardWidth,
            child: cardMaker.card(FlutterLogo(colors: Colors.red)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: cardMarginH, vertical: cardMarginV),
            width: cardWidth,
            child: cardMaker.card(FlutterLogo(colors: Colors.red)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: cardMarginH, vertical: cardMarginV),
            width: cardWidth,
            child: cardMaker.card(FlutterLogo(colors: Colors.red)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: cardMarginH, vertical: cardMarginV),
            width: cardWidth,
            child: cardMaker.card(FlutterLogo(colors: Colors.red)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: cardMarginH, vertical: cardMarginV),
            width: cardWidth,
            child: cardMaker.card(FlutterLogo(colors: Colors.red)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: cardMarginH, vertical: cardMarginV),
            width: cardWidth,
            child: cardMaker.card(FlutterLogo(colors: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _showWeekPow(){
    final double textMargin = 20.0;

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: textMargin, vertical: textMargin),
          height: 30.0,
          child: Text("Teste", style: TextStyle(fontSize: 18.0),),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: textMargin, vertical: textMargin),
          height: 30.0,
          child: Text("Teste", style: TextStyle(fontSize: 18.0),),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: textMargin, vertical: textMargin),
          height: 30.0,
          child: Text("Teste", style: TextStyle(fontSize: 18.0),),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: textMargin, vertical: textMargin),
          height: 30.0,
          child: Text("Teste", style: TextStyle(fontSize: 18.0),),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: textMargin, vertical: textMargin),
          height: 30.0,
          child: Text("Teste", style: TextStyle(fontSize: 18.0),),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: textMargin, vertical: textMargin),
          height: 30.0,
          child: Text("Teste", style: TextStyle(fontSize: 18.0),),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: textMargin, vertical: textMargin),
          height: 30.0,
          child: Text("Teste", style: TextStyle(fontSize: 18.0),),
        ),
      ],
    );
  }

}