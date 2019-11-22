import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:helius_app/components/chart_card.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _WeatherScreenPage();
}

class _WeatherScreenPage extends State<WeatherScreen> {
  ChartCard cardMaker = ChartCard();

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
    return Container(
      child: StaggeredGridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 0.0,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: cardMaker.card(_cardContent("Temperatura Ambiente", "31", "ºC")),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: cardMaker.card(_cardContent("Umidade", "18", "%")),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: cardMaker.card(_cardContent("Índice UV", "2", "")),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: cardMaker.card(_cardContent("Irradiação solar", "1460", "W/m²")),
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