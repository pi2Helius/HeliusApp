import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:helius_app/components/chart_card.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _WeatherScreenPage();
}

class _WeatherScreenPage extends State<WeatherScreen> {
  //Variables
  String radiation = "";
  var isLoading = true;
  Map<String, dynamic> weatherData = Map<String, dynamic>();
  final String weatherURL = "http://apiadvisor.climatempo.com.br/api/v1/weather/locale/8173/current?token=6aece1fb4baacadf9d93355fe9a39068";
  
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
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StaggeredGridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 0.0,
        children: isLoading ? _buildCardsLoading() : _buildCardsWithContent(),
        staggeredTiles: [
          StaggeredTile.extent(4, 100.0),
          StaggeredTile.extent(2, 200.0),
          StaggeredTile.extent(2, 200.0),
          StaggeredTile.extent(2, 200.0),
          StaggeredTile.extent(2, 200.0),
        ],
      ),
    );
  }

  List<Widget> _buildCardsWithContent(){
    String condition = weatherData['data']['condition'].toString();
    String temperature = weatherData['data']['temperature'].toString();
    String humidity = weatherData['data']['humidity'].toString();
    String windVelocity = weatherData['data']['wind_velocity'].toString();
    String location = weatherData['name'].toString();

    return <Widget>[
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: cardMaker.card(_cardContent(location, condition, "")),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: cardMaker.card(_cardContent("Temperatura Ambiente", temperature, "ºC")),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: cardMaker.card(_cardContent("Umidade", humidity, "%")),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: cardMaker.card(_cardContent("Velocidade Vento", windVelocity, "km/h")),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: cardMaker.card(_cardContent("Irradiação Solar", radiation, "W/m²")),
      ),
    ];
  }

  List<Widget> _buildCardsLoading(){
    return <Widget>[
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: cardMaker.card(Center(child: CircularProgressIndicator(),)),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: cardMaker.card(Center(child: CircularProgressIndicator(),)),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: cardMaker.card(Center(child: CircularProgressIndicator(),)),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: cardMaker.card(Center(child: CircularProgressIndicator(),)),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: cardMaker.card(Center(child: CircularProgressIndicator(),)),
      ),
    ];
  }

  _fetchData() async {
    if(this.mounted){
      setState(() {
        isLoading = true;
      });

      // Getting data from Firebase
      CollectionReference heliusCollection = Firestore.instance.collection('Usina');
      DocumentReference documentReference = heliusCollection.document('teste');
      DocumentSnapshot documentSnapshot = await documentReference.get();
      setState(() {
        radiation = documentSnapshot['IRRAD_LDR'].round().toString();
      });

      // Getting data from API
      final response = await http.get(weatherURL);
      // print('Waiting response...');

      if (response.statusCode == 200){
        // print('Got response!');
        weatherData = json.decode(response.body);
        // print('Response with id ' + weatherData['id'].toString());

        setState(() {
          isLoading = false;
        });

      } else {
        throw Exception('Failed to load weather data!');
      }
    }


  }



}