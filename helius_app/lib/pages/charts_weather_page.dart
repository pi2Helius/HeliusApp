import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:helius_app/components/chart_card.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _WeatherScreenPage();
}

class _WeatherScreenPage extends State<WeatherScreen> {
  ChartCard cardMaker = ChartCard();

  Material card(Widget content){
    return Material(
      color: Colors.white,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      shadowColor: Colors.grey[400],
      child: content,
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
            child: cardMaker.card(FlutterLogo(colors: Colors.red)),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: cardMaker.card(FlutterLogo(colors: Colors.green)),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: cardMaker.card(FlutterLogo(colors: Colors.blue)),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: cardMaker.card(FlutterLogo(colors: Colors.purple)),
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