import 'package:flutter/material.dart';
import '../data_table.dart';
import '../data/database_service.dart';
import '../data/models/models.dart';
import '../manage_show_form.dart';

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

  @override
  Widget build(BuildContext context) {
    var callback = () => getOngoingShows();
    return Scaffold(
      body: Center(
        child: DataTableSanctum(_ongoingShows, callback),
      ),
      floatingActionButton: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child:
          FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => ManageOngoingShowForm(null)
                ).then((_) => getOngoingShows());
              },
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Color(0xff14C460)
          )
      ),
    );
  }
}