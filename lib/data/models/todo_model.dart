import 'package:flutter/widgets.dart';
import 'IDBModel.dart';

class Todo implements IDBModel {
  @override
  final String title;
  final String type;

  Todo({
    required this.title,
    required this.type
  });

  @override
  List<String> getColumnHeaders() {
    return ["Title", "Type"];
  }

  @override
  List<Container> getTableRowValues(Color rowColor, EdgeInsets rowPadding) {
    return [
      Container(color: rowColor, padding: rowPadding, child: Text(this.title)),
      Container(color: rowColor, padding: rowPadding, child: Text(this.type)),
    ];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
    };
  }
}