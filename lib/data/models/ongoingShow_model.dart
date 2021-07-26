import 'package:flutter/widgets.dart';
import 'IDBModel.dart';

class OngoingShow implements IDBModel {
  @override
  final String title;

  OngoingShow({
    required this.title,
  });

  @override
  List<String> getColumnHeaders() {
    return ["Title"];
  }

  @override
  List<Container> getTableRowValues(Color rowColor, EdgeInsets rowPadding) {
    return [
      Container(color: rowColor, padding: rowPadding, child: Text(this.title)),
    ];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }
}