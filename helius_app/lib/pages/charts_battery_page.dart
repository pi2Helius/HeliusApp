import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:helius_app/components/chart_card.dart';

class BatteryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _BatteryScreenPage();
}

class _BatteryScreenPage extends State<BatteryScreen> {
  var data = [0.1, 1.1, 0.5, -0.1, 0.3, -0.1, 0.1, 2.1];

  ChartCard cardMaker = ChartCard();

  Widget _potEleChart(){
    return new Sparkline(
      data: data,
      fillMode: FillMode.below,
      fillGradient: new LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.amber[800], Colors.amber[200]],
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