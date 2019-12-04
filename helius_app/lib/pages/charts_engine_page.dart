import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:helius_app/components/chart_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EngineScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _EngineScreenPage();
}

class _EngineScreenPage extends State<EngineScreen> {
  ChartCard cardMaker = ChartCard();
  var isLoading = true;

  final CollectionReference heliusCollection = Firestore.instance.collection('usinas');

  String hotPiston = "";
  String coldPiston = "";
  String mirrorTemp = "";
  String engSpin = "";

  @override
  void initState() {
    _prepareData(heliusCollection, "usina1");
    super.initState();
  }

  void _prepareData(CollectionReference collectionReference, String id) async{
    DocumentReference documentReference = collectionReference.document(id);
    DocumentSnapshot documentSnapshot = await documentReference.get();

    if(this.mounted){
      setState(() {
        isLoading = true;
      });

      setState(() {
        hotPiston = documentSnapshot['TEMP_PQUENTE'].round().toString();
        coldPiston = documentSnapshot['TEMP_PFRIO'].round().toString();
        mirrorTemp = documentSnapshot['TEMP_REFLETOR'].round().toString();
        engSpin = documentSnapshot['ROT'].round().toString();

        isLoading = false;
      });
    }
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
                  child: isLoading ? CircularProgressIndicator() : Text( valueString, style: TextStyle(
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
    _prepareData(heliusCollection, "usina1");

    return Container(
      child: StaggeredGridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 0.0,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: cardMaker.card(_cardContent("Pistão quente", hotPiston, "ºC")),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: cardMaker.card(_cardContent("Pistão frio", coldPiston, "ºC")),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: cardMaker.card(_cardContent("Temp espelho", mirrorTemp, "ºC")),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: cardMaker.card(_cardContent("Rotação do motor", engSpin, "RPM")),
          ),
        ],

        staggeredTiles: [
          StaggeredTile.extent(2, 250.0),
          StaggeredTile.extent(2, 250.0),
          StaggeredTile.extent(2, 250.0),
          StaggeredTile.extent(2, 250.0),
        ],
      ),
    );
  }
}