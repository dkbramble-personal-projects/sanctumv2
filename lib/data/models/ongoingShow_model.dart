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
  List<String> getColumnHeaders() {
    return ["Title"];
  }

  @override
  List<Container> getTableRowValues(Color rowColor, BuildContext context, VoidCallback callback) {
    return [
      Container(color: rowColor,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5),
            ),
            onPressed: () => showDialog(
                context: context,
                builder: (context) => ManageOngoingShowForm(this)
            ).then((_) => callback()),
            child: Text(this.title, style: TextStyle(color: Colors.white)),
          )
      ),
    ];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
    };
  }
}