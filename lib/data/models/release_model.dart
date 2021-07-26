import 'package:flutter/widgets.dart';
import 'IDBModel.dart';

class Release implements IDBModel {
  @override
  final String title;
  final String type;
  final int releaseDate;
  final int checkDate;

  Release({
    required this.title,
    required this.type,
    required this.releaseDate,
    required this.checkDate
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
      Container(color: rowColor, padding: rowPadding, child: Text(this.releaseDate.toString())),
    ];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'releaseDate': releaseDate,
      'checkDate': checkDate,
    };
  }
}