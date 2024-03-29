import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:helius_app/pages/charts_battery_page.dart';
import 'package:helius_app/pages/charts_engine_page.dart';
import 'package:helius_app/pages/charts_weather_page.dart';
import 'package:helius_app/pages/charts_prediction_page.dart';

class ChartsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ChartsScreenPage();
}

class _ChartsScreenPage extends State<ChartsScreen> {
  final Map<int, Widget> infoNames = const <int, Widget>{
    0: Text('Bateria'),
    1: Text('Motor'),
    2: Text('Clima'),
    3: Text('Previsão'),
  };

  final Map<int, Widget> infoScreen = <int, Widget>{
    0: Center(
      child: BatteryScreen(),
    ),
    1: Center(
      child: EngineScreen(),
    ),
    2: Center(
      child: WeatherScreen(),
    ),
    3: Center(
      child: PredictionScreen(),
    ),
  };

  int sharedValue = 0;

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: _segmentedControll(),
        ),
        Expanded(
          child: infoScreen[sharedValue],
        ),
      ],
    );
  }

  Widget _segmentedControll(){
    return new CupertinoSegmentedControl<int>(
      children: infoNames,
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      onValueChanged: (int val){
        setState(() {
          sharedValue = val;
        });
      },
      groupValue: sharedValue,
    );
  }

}