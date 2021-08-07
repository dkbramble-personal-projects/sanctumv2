import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'data/models/models.dart';

//ignore: must_be_immutable
class DataTableSanctum extends StatelessWidget  {
  late List<IDBModel> _data;
  VoidCallback _setData = () => {};

  DataTableSanctum(List<IDBModel> data, VoidCallback setData) {
    _data = data;
    _setData = setData;
  }

  @override
  Widget build(BuildContext context){
    return createTable(this._data, context, this._setData);
  }
}

Widget createTable(List<IDBModel> data, BuildContext context, VoidCallback setData) {
  if (data == null || data.isEmpty) {
    return Text("Nothing to Show...");
  }

  var headerColumnNames = data.first.getColumnHeaders();
  List<Expanded> headerColumns = [];
  var rowPadding = EdgeInsets.symmetric(vertical: 5, horizontal: 10);

  List<IntrinsicHeight> allRows = [];

  headerColumnNames.keys.forEach((columnName) {
    headerColumns.add(Expanded(flex: headerColumnNames[columnName] ?? 1, child:Container(color: Color(0xFF212121), padding: rowPadding, child: Text(columnName, textAlign: TextAlign.center,))));
  });

  allRows.add(IntrinsicHeight(child: Row( crossAxisAlignment: CrossAxisAlignment.stretch, children: headerColumns)));
  int rowCount = 0;
  Color rowColor = Color(0xFF424242);

  data.forEach((record)
  {
    allRows.add(IntrinsicHeight(child:Row( crossAxisAlignment: CrossAxisAlignment.stretch, children: record.getTableRowValues(rowColor, context, setData))));
    rowColor = rowCount % 2 == 0 ? Color(0xFF212121) : Color(0xFF424242);
    rowCount++;
  });

  allRows.add(IntrinsicHeight(child: Container(padding: EdgeInsets.symmetric(vertical: 60),),));

  return ListView(
      children: allRows
  );
}