import 'package:flutter/widgets.dart';
import 'IDBModel.dart';
import '../../manage_show_form.dart';
import 'package:flutter/material.dart';

class OngoingShow implements IDBModel {
  @override
  final String title;

  OngoingShow({
    required this.title,
  });

  @override
  Map<String, int> getColumnHeaders() {
    return {"Title": 1};
  }

  @override
  List<Expanded> getTableRowValues(Color rowColor, BuildContext context, VoidCallback callback) {
    return [
    Expanded(flex:1, child: Container(color: rowColor,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5),
            ),
            onPressed: () => showDialog(
                context: context,
                builder: (context) => ManageOngoingShowForm(this)
            ).then((_) => callback()),
            child: Center( child: Text(this.title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
          )
      )),
    ];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }

  Map<String, dynamic> toJson() => {
    'title': title,
  };
}