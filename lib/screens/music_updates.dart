import 'package:flutter/material.dart';
import 'package:sanctumv2/data/database_service.dart';
import '../data_table.dart';
import '../data/models/models.dart';
import '../data/spoofy_service.dart';

class MusicReleases extends StatefulWidget {
  @override
  _MusicReleasesState createState() => _MusicReleasesState();
}

class _MusicReleasesState extends State<MusicReleases> {
  List<MusicRelease> _music = [];
  bool _isFetching = false;

  @override
  void initState(){
    getLocalReleases();
    super.initState();
  }

  getLocalReleases() async {
    var db = DatabaseService();
    var music = await db.getMusic();
    if (this.mounted) {
      setState(() {
        _music = music;
        _isFetching = false;
      });
    }
  }

  void getReleases() async {
    setState(() {
      _isFetching = true;
    });
    var spoofyService = SpoofyService();
    await spoofyService.fetchMusicData();
    await getLocalReleases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isFetching ? CircularProgressIndicator() : Container( child:
        RefreshIndicator(
          child: DataTableSanctum(_music, () => {}),
          onRefresh: () async => getReleases(),
        )),
      ),
    );
  }
}