import 'package:flutter/widgets.dart';

class IDBModel {
  final String title = "";

  Map<String, dynamic> toMap() { return new Map<String, dynamic>();}
  List<String> getColumnHeaders() { return new List<String>.empty(growable: true);}
  List<Container> getTableRowValues(Color rowColor, BuildContext context, VoidCallback callback) { return new List<Container>.empty(growable: true);}
}