import 'package:flutter/material.dart';
import '../data_table.dart';
import '../data/database_service.dart';
import '../data/models/models.dart';

class OngoingShows extends StatefulWidget {
  @override
  _OngoingShowsState createState() => _OngoingShowsState();
}

class _OngoingShowsState extends State<OngoingShows> {
  List<OngoingShow> _ongoingShows = List<OngoingShow>.empty(growable: true);

  @override
  void initState(){
    getOngoingShows();
    super.initState();
  }

  void getOngoingShows() async {
    var databaseService = DatabaseService();
    var ongoingShows = await databaseService.getOngoingShows();
    setState(() {
      _ongoingShows = ongoingShows;
    });
  }

  void _addRecord() async {
    var databaseService = DatabaseService();
    var release = new OngoingShow(title: "Twelve Minutes");
    await databaseService.insertRecord(release, 'ongoingShows');
    getOngoingShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DataTableSanctum(_ongoingShows),
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