import 'package:flutter/material.dart';
import '../data_table.dart';
import '../data/models/models.dart';

class MusicReleases extends StatefulWidget {
  @override
  _MusicReleasesState createState() => _MusicReleasesState();
}

class _MusicReleasesState extends State<MusicReleases> {
  List<MusicRelease> _music = List<MusicRelease>.empty(growable: true);

  @override
  void initState(){
    getReleases();
    super.initState();
  }

  void getReleases() async {
    // var databaseService = DatabaseService();
    // var releases = await databaseService.getReleases();
    // setState(() {
    //   _releases = releases;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DataTableSanctum(_music, () => {}),
      )
    );
  }
}