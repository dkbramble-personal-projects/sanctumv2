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
  if (data.isEmpty) {
    return Text("Waiting For Data...");
  }

  var headerColumnNames = data.first.getColumnHeaders();
  List<Container> headerColumns = List<Container>.empty(growable: true);
  var rowPadding = EdgeInsets.symmetric(vertical: 5, horizontal: 10);

  headerColumnNames.forEach((columnName) {
    headerColumns.add(Container(color: Color(0xFF212121), padding: rowPadding, child: Text(columnName, textAlign: TextAlign.center,)));
  });

  List<TableRow> headerRow = [];
  headerRow.add(TableRow( children: headerColumns));

  var columnWidths = const <int, TableColumnWidth>{
    0: FixedColumnWidth(220),
    1: FixedColumnWidth(70),
    2: FlexColumnWidth()
  };

  var header = Table(
    children: headerRow,
    columnWidths: columnWidths,
    border: TableBorder(bottom: BorderSide(width: 1, color: Color(0xff14C460)), verticalInside: BorderSide(width: 1, color: Color(0xff14C460)) )
  );

  List<TableRow> rows = [];
  int rowCount = 0;
  Color rowColor = Color(0xFF424242);

  data.forEach((record)
  {
    rows.add(TableRow( children: record.getTableRowValues(rowColor, context, setData)));
    rowColor = rowCount % 2 == 0 ? Color(0xFF212121) : Color(0xFF424242);
    rowCount++;
  });

  var table = Table(
    children: rows,
    columnWidths: columnWidths,
    border: TableBorder(verticalInside: BorderSide(width: 1, color: Colors.white)),
  );

  var bottomRowPadding = Container(color: rowColor, padding: EdgeInsets.symmetric(vertical:20,  horizontal: 0));

  return ListView(
      children: <Widget> [
        header,
        table,
        bottomRowPadding
      ]
  );
}