import 'package:flutter/material.dart';

class ChartCard{
  Material card(Widget content){
    return Material(
      color: Colors.white,
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      shadowColor: Colors.grey[400],
      child: content,
      );
  }
}