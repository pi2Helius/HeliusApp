import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _NotificationScreenPage();
}

class _NotificationScreenPage extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    return _createList(context);
  }

  Widget _createList(BuildContext context){
    var collectionNotfic = Firestore.instance.collection('usinas').document('usina1').collection('notificacoes');

    return StreamBuilder(
      stream: collectionNotfic.snapshots(),
      builder: (context, snapshot){
        return ListView.builder(
          itemCount: snapshot.data?.documents?.length ?? 0,
          itemBuilder: (context, index) => _buildNotificationItem(context, snapshot.data.documents[index])
        );
      }
    );
  }

  //Build Card
  Widget _buildNotificationItem(BuildContext context, DocumentSnapshot document){
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 50.0,
              child: Text(document['descricao'], style: TextStyle(fontWeight: FontWeight.w500)),
            )
          ),

          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              child: Text(_convertTimestamp(document['data']), style: TextStyle(fontWeight: FontWeight.w300)),
            )
          )
        ],
        ),
    );
  }

  String _convertTimestamp(Timestamp timestamp){
    var timeMilliseconds = timestamp.millisecondsSinceEpoch;

    var date = new DateTime.fromMillisecondsSinceEpoch(timeMilliseconds);
    var format = new DateFormat.yMd().add_jm();
    var finalDate = format.format(date);

    return finalDate;
  }
}