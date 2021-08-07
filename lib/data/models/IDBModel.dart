import 'package:flutter/widgets.dart';

class IDBModel {
  final String title = "";

  Map<String, dynamic> toMap() { return new Map<String, dynamic>();}
  Map<String, int> getColumnHeaders() { return {};}
  List<Expanded> getTableRowValues(Color rowColor, BuildContext context, VoidCallback callback) { return [];}
}