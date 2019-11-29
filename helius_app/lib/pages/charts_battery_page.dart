import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:helius_app/components/chart_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:helius_app/components/predicao.dart' as pred;

class BatteryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _BatteryScreenPage();
}

class _BatteryScreenPage extends State<BatteryScreen> {
  // Variables
  var data = [1.0, 0.0, 1.0, 0.0, 1.0, 1.0, 2.0, 2.0];
  String vBattery = "";
  double pow = 0.0;
  double irradAtual = 0.0;
  List<dynamic> irradElevDataList = [];

  final DateFormat formatHour = new DateFormat.H();
  final DateFormat formatDay = new DateFormat("dd/MM");
  DateTime dateNow = new DateTime.now();

  final databaseReference = FirebaseDatabase.instance.reference();
  final CollectionReference heliusCollection = Firestore.instance.collection('usinas');
  ChartCard cardMaker = ChartCard();

  Future<DocumentSnapshot> _getDocumentById(CollectionReference collectionReference, String id) async {
    DocumentReference documentReference = collectionReference.document(id);
    DocumentSnapshot documentSnapshot = await documentReference.get();

    //Defining generator's power
    // print('passou1');
    if(this.mounted){
      setState(() {
        pow = documentSnapshot['IGER'] * documentSnapshot['VGER'];
        vBattery = documentSnapshot['VBAT'].toStringAsFixed(2);
        irradAtual = documentSnapshot['IRRAD_LDR']*1.0;
      });
    }

    // Getting data from Realtime Database
    DataSnapshot dataSnapshot = await databaseReference.once();
    irradElevDataList = dataSnapshot.value['elevacao_radiacao'];

    //Defining generator's power chart content
    // QuerySnapshot historySnapshots = await documentReference.collection('historico').getDocuments();
    // var list = historySnapshots.documents;
    // print('passou2');

    // for (var i = 7; i >= 0; i--) {
    //   data[i] = list[i].data['IGER'];
    // }

    // for (var i = 7; i >= 0; i--) {
    //   print(data[i].toString() + '  ');
    // }

    return documentSnapshot;
  }

  double getPredictedPower(){
    String data = formatDay.format(dateNow);
    String hour = formatHour.format(dateNow);

    for (var element in irradElevDataList) {
      if(element['data'] == data){
        if(element['hora'].toString() == hour){
          double predPower = pred.predicao(element['elevacao'], irradAtual, 45.0);
          return predPower;
        }
      } 
    }

    return 0.0;
  }

  String getEfficiency () {
    double predPower = getPredictedPower();

    if (predPower <= 0.0){
      return "N/A";
    }

    double efficiency = (pow/predPower) * 100.0;
    return efficiency.round().toString(); 
  }

  Widget _potEleChart(List data, String value){
    // print('\n\n\ndesenhou!!!!!\n\n\n');
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
                  child: Text("Potência Gerador", style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey),),
                ),

                //Value
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text( value+' W', style: TextStyle(
                    fontSize: 48.0),),
                ),

                //Chart
                // Padding(
                //   padding: EdgeInsets.all(1.0),
                //   child: new Sparkline(
                //     data: data,
                //     lineColor: Colors.red,
                //     fillMode: FillMode.below,
                //     fillGradient: new LinearGradient(
                //       begin: Alignment.topCenter,
                //       end: Alignment.bottomCenter,
                //       colors: [Colors.amber[800], Colors.amber[200]],
                //     ),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Material card(Widget content){
    return Material(
      color: Colors.white,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      shadowColor: Colors.grey[400],
      child: content,
      );
  }

  Widget _cardContent(String title, String value, String unity){
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
                    fontSize: 16.0,
                    color: Colors.grey[500]),),
                ),

                //Value
                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text( valueString, style: TextStyle(
                    fontSize: 30.0),),
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

    return Container(
      child: StaggeredGridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 0.0,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: cardMaker.card(_cardContent("Tensão Bateria", vBattery, "V")),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: cardMaker.card(_cardContent("Eficiência", getEfficiency(), "%")),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: cardMaker.card(_potEleChart(data, pow.round().toString())),
          ),
        ],
        staggeredTiles: [
          StaggeredTile.extent(2, 250.0),
          StaggeredTile.extent(2, 250.0),
          StaggeredTile.extent(4, 250.0),
        ],
      ),
    );
  }
}