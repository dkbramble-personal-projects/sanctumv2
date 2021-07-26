import 'package:flutter/material.dart';
import '../data_table.dart';
import '../data/database_service.dart';
import '../data/models/models.dart';

class Rumors extends StatefulWidget {
  @override
  _RumorsState createState() => _RumorsState();
}

class _RumorsState extends State<Rumors> {
  List<Rumor> _rumors = List<Rumor>.empty(growable: true);

  @override
  void initState(){
    getRumors();
    super.initState();
  }

  void getRumors() async {
    var databaseService = DatabaseService();
    var rumors = await databaseService.getRumors();
    setState(() {
      _rumors = rumors;
    });
  }

  void _addRecord() async {
    var databaseService = DatabaseService();
    var release = new Rumor(title: "Twelve Minutes", type: "Game", releaseWindow: "2021");
    await databaseService.insertRecord(release, 'rumors');
    getRumors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DataTableSanctum(_rumors),
      ),
      floatingActionButton: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child:
          FloatingActionButton(
              onPressed: _addRecord,
              tooltip: 'Increment',
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Color(0xff14C460)
          )
      ),
    );
  }
}