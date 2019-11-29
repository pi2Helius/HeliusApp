import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:helius_app/components/chart_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:helius_app/components/predicao.dart' as pred;
import 'package:intl/intl.dart';

class PredictionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PredictionScreenPage();
}

class _PredictionScreenPage extends State<PredictionScreen> {
  // Variables
  double irradAtual = 0.0;
  List<dynamic> irradElevDataList = [];
  ChartCard cardMaker = ChartCard();

  final CollectionReference heliusCollection = Firestore.instance.collection('usinas');
  final databaseReference = FirebaseDatabase.instance.reference();
  final DateFormat formatHour = new DateFormat.H();
  final DateFormat formatDay = new DateFormat("dd/MM");
  DateTime dateNow = new DateTime.now();

  Future<DocumentSnapshot> _getDocumentById(CollectionReference collectionReference, String id) async {
    DocumentReference documentReference = collectionReference.document(id);
    DocumentSnapshot documentSnapshot = await documentReference.get();

    if(this.mounted){
      setState(() {
        irradAtual = documentSnapshot['IRRAD_LDR']*1.0;
      });
    }

    // Getting from Realtime Database
    DataSnapshot dataSnapshot = await databaseReference.once();
    irradElevDataList = dataSnapshot.value['elevacao_radiacao'];

    return documentSnapshot;
  }

  double getAtualElev(){

    String data = formatDay.format(dateNow);
    String hour = formatHour.format(dateNow);

    for (var element in irradElevDataList) {
      if(element['data'] == data){
        if(element['hora'].toString() == hour){
          return element['elevacao'];
        }
      } 
    }

    return 0.0;
  }

  double getIrradHist(int hour){

    String data = formatDay.format(dateNow);

    for (var element in irradElevDataList) {
      if(element['data'] == data){
        if(element['hora'] == hour){
          return element['radiacao'];
        }
      } 
    }

    return 0.0;
  }  

  double getElevHist(int hour){

    String data = formatDay.format(dateNow);

    for (var element in irradElevDataList) {
      if(element['data'] == data){
        if(element['hora'] == hour){
          return element['elevacao'];
        }
      } 
    }

    return 0.0;
  }

  String getPowHourDayAhead(int numDayAhead){
    
    String data = formatDay.format(dateNow);

    for (var element in irradElevDataList) {
      if(element['data'] == data){
        int index = irradElevDataList.indexOf(element);
        int initialIndex = index+(6*numDayAhead);

        double powTotal = 0.0;
        for (var i = initialIndex; i < initialIndex+6; i++) {
          powTotal = powTotal + pred.predicao(irradElevDataList[i]['elevacao'] , irradElevDataList[i]['radiacao'], 45.0);
        }

        double avgPow = powTotal/6;
        return avgPow.round().toString();
      }
    }

    return "*Day not found*";
  }

  Widget _cardContent(String title, String value, String unity, double fontSizeTitle, double fontSizeData){
    String valueString = value + " " + unity;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Title
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text(title, style: TextStyle(
                    fontSize: fontSizeTitle,
                    color: Colors.grey[500]),),
                ),

                //Value
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text( valueString, style: TextStyle(
                    fontSize: fontSizeData),),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<DocumentSnapshot> document = _getDocumentById(heliusCollection, "usina1");

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
      child: cardMaker.card(_cardContent("Previsão Potência Atual", pred.predicao(this.getAtualElev(), irradAtual, 45.0).toStringAsFixed(2), "W", 18.0, 30.0)),
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
            child: cardMaker.card(_cardContent("11h", pred.predicao(getElevHist(11), getIrradHist(11), 45.0).round().toString(), "W", 16.0, 18.0)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: cardMarginH, vertical: cardMarginV),
            width: cardWidth,
            child: cardMaker.card(_cardContent("12h", pred.predicao(getElevHist(12), getIrradHist(12), 45.0).round().toString(), "W", 16.0, 18.0)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: cardMarginH, vertical: cardMarginV),
            width: cardWidth,
            child: cardMaker.card(_cardContent("13h", pred.predicao(getElevHist(13), getIrradHist(13), 45.0).round().toString(), "W", 16.0, 18.0)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: cardMarginH, vertical: cardMarginV),
            width: cardWidth,
            child: cardMaker.card(_cardContent("14h", pred.predicao(getElevHist(14), getIrradHist(14), 45.0).round().toString(), "W", 16.0, 18.0)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: cardMarginH, vertical: cardMarginV),
            width: cardWidth,
            child: cardMaker.card(_cardContent("15h", pred.predicao(getElevHist(15), getIrradHist(15), 45.0).round().toString(), "W", 16.0, 18.0)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: cardMarginH, vertical: cardMarginV),
            width: cardWidth,
            child: cardMaker.card(_cardContent("16h", pred.predicao(getElevHist(16), getIrradHist(16), 45.0).round().toString(), "W", 16.0, 18.0)),
          ),
        ],
      ),
    );
  }

  Widget _showDayListItem(String weekDay, String value, double textMargin){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: textMargin, vertical: textMargin),
          height: 30.0,
          child: Text(weekDay, style: TextStyle(fontSize: 18.0),),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: textMargin, vertical: textMargin),
          height: 30.0,
          child: Text(value + " W/h", style: TextStyle(fontSize: 18.0),),
        ),
      ],
    );
  }

  Widget _showWeekPow(){
    final double textMargin = 20.0;

    return Container(
      height: 280.0,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          _showDayListItem("Sábado", getPowHourDayAhead(1), textMargin),
          _showDayListItem("Domingo", getPowHourDayAhead(2), textMargin),
          _showDayListItem("Segunda-feira", getPowHourDayAhead(3), textMargin),
          _showDayListItem("Terça-feira", getPowHourDayAhead(4), textMargin),
          _showDayListItem("Quarta-feira", getPowHourDayAhead(5), textMargin),
          _showDayListItem("Quinta-feira", getPowHourDayAhead(6), textMargin),
          _showDayListItem("Sexta-feira", getPowHourDayAhead(7), textMargin),
        ],
      ),
    );
  }

}