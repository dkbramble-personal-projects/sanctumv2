import 'package:flutter/widgets.dart';
import 'IDBModel.dart';

class Rumor implements IDBModel {
  @override
  final String title;
  final String type;
  final String releaseWindow;

  Rumor({
    required this.title,
    required this.type,
    required this.releaseWindow
  });

  @override
  List<String> getColumnHeaders() {
    return ["Title", "Type", "Release"];
  }

  @override
  List<Container> getTableRowValues(Color rowColor, EdgeInsets rowPadding) {
    return [
      Container(color: rowColor, padding: rowPadding, child: Text(this.title)),
      Container(color: rowColor, padding: rowPadding, child: Text(this.type)),
      Container(color: rowColor, padding: rowPadding, child: Text(this.releaseWindow.toString())),
    ];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'releaseWindow': releaseWindow,
    };
  }
}