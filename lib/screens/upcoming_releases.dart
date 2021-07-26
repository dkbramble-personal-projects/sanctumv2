import 'package:flutter/material.dart';
import '../data_table.dart';
import '../data/database_service.dart';
import '../data/models/models.dart';
import '../add_record_dialog.dart';

class UpcomingReleases extends StatefulWidget {
  @override
  _UpcomingReleasesState createState() => _UpcomingReleasesState();
}

class _UpcomingReleasesState extends State<UpcomingReleases> {
  List<Release> _releases = List<Release>.empty(growable: true);

  @override
  void initState(){
    getReleases();
    super.initState();
  }

  void getReleases() async {
    var databaseService = DatabaseService();
    var releases = await databaseService.getReleases();
    setState(() {
      _releases = releases;
    });
  }

  void _addRecord() async {
    // var databaseService = DatabaseService();
    // var release = new Release(title: "Twelve Minutes", type: "Game", releaseDate: 0, checkDate: 1);
    // await databaseService.insertRecord(release, 'releases');
    // getReleases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DataTableSanctum(_releases),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child:
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context, 
                builder: (context) => buildPopupDialog(context)
              ).then((_) => getReleases());
            },
            child: Icon(Icons.add, color: Colors.white),
            backgroundColor: Color(0xff14C460)
          )
      ),
    );
  }
}