import 'package:flutter/widgets.dart';
import '../../manage_release_form.dart';
import 'IDBModel.dart';
import 'package:flutter/material.dart';

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
    return ["Title", "Type", "Days Left"];
  }

  @override
  List<Container> getTableRowValues(Color rowColor, BuildContext context, VoidCallback callback) {

    var utcDate = DateTime.now().toUtc();
    var currentUtcDate = DateTime.now().toUtc();
    var dayCount = 0;
    var countColor = rowColor;
    bool hasRelease = this.releaseDate >= 0;

    if (hasRelease){
      utcDate = DateTime.fromMillisecondsSinceEpoch(this.releaseDate * 1000).toUtc();
      currentUtcDate = DateTime.now().toUtc();
      dayCount = (utcDate.difference(currentUtcDate).inHours / 24).round();
      countColor = dayCount < 1 ? Color(0xff14C460) : rowColor;
    }

    return [
      Container(color: rowColor,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5),
            ),
            onPressed: () => showDialog(
                context: context,
                builder: (context) => ManageReleaseForm(this)
            ).then((_) => callback()),
            child: Text(this.title, style: TextStyle(color: Colors.white)),
          )
      ),
      Container(color: rowColor, padding: EdgeInsets.symmetric(vertical: 15), child: Text(this.type, textAlign: TextAlign.center)),
      Container(color: countColor, padding: EdgeInsets.symmetric(vertical: 15), child: Text( hasRelease ? dayCount.toString() : "", textAlign: TextAlign.center)),
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