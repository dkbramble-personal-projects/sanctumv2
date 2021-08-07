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
  Map<String, int> getColumnHeaders() {
    return {"Title": 2, "Type": 1, "Days Left": 1};
  }

  @override
  List<Expanded> getTableRowValues(Color rowColor, BuildContext context, VoidCallback callback) {

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
      Expanded(flex:2, child: Container(color: rowColor,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
            onPressed: () => showDialog(
                context: context,
                builder: (context) => ManageReleaseForm(this)
            ).then((_) => callback()),
            child: Text(this.title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
          ),
      )),
      Expanded(flex: 1, child:Container(color: rowColor, padding: EdgeInsets.symmetric(vertical: 15), child: Text(this.type, textAlign: TextAlign.center))),
      Expanded(flex: 1, child:Container(color: countColor, padding: EdgeInsets.symmetric(vertical: 15), child: Text( hasRelease ? dayCount.toString() : "", textAlign: TextAlign.center))),
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