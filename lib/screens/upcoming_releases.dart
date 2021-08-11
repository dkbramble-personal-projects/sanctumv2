import 'package:flutter/material.dart';
import '../data_table.dart';
import '../data/database_service.dart';
import '../data/igdb_service.dart';
import '../data/models/models.dart';
import '../manage_release_form.dart';


class UpcomingReleases extends StatefulWidget {
  @override
  _UpcomingReleasesState createState() => _UpcomingReleasesState();
}

class _UpcomingReleasesState extends State<UpcomingReleases> {
  List<Release> _releases = [];

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

  void updateReleaseDates() async {
    var igdbService = IGDBService();
    await igdbService.getReleaseData();
    getReleases();
  }

  @override
  Widget build(BuildContext context) {
    var callback = () => getReleases();
    return Scaffold(
      body:Container( child:
        RefreshIndicator(
            child: DataTableSanctum(_releases, callback),
            onRefresh: () async => updateReleaseDates(),
      )),
      floatingActionButton: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child:
          FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => ManageReleaseForm(null)
                ).then((_) => getReleases());
              },
            child: Icon(Icons.add, color: Colors.white),
            backgroundColor: Color(0xff14C460)
          )

      ),
    );
  }
}

