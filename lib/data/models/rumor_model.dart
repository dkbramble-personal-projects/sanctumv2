import 'package:flutter/widgets.dart';
import 'IDBModel.dart';
import '../../manage_rumor_form.dart';
import 'package:flutter/material.dart';

class Rumor implements IDBModel {
  @override
  final String title;
  final String type;
  final String? releaseWindow;

  Rumor({
    required this.title,
    required this.type,
    required this.releaseWindow
  });

  @override
  Map<String, int> getColumnHeaders() {
    return {"Title": 2, "Type":1, "Release": 1};
  }

  @override
  List<Expanded> getTableRowValues(Color rowColor, BuildContext context, VoidCallback callback) {
    return [
    Expanded(flex:2, child: Container(color: rowColor,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5),
            ),
            onPressed: () => showDialog(
                context: context,
                builder: (context) => ManageRumorForm(this)
            ).then((_) => callback()),
            child: Center(child: Text(this.title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),),
          )
      )),
    Expanded(flex:1, child:Container(color: rowColor, padding: EdgeInsets.symmetric(vertical: 15), child: Center(child: Text(this.type, textAlign: TextAlign.center)))),
    Expanded(flex:1, child:Container(color: rowColor, padding: EdgeInsets.symmetric(vertical: 15), child: Center(child: Text(this.releaseWindow ?? "", textAlign: TextAlign.center)))),
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

  Map<String, dynamic> toJson() => {
    'title': title,
    'type': type,
  };
}