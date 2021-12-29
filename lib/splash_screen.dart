import 'package:flutter/material.dart';
import 'navigation_bar.dart';
import 'data/database_service.dart';
import 'data/igdb_service.dart';

class RouteSplash extends StatefulWidget {
  @override
  _RouteSplashState createState() => _RouteSplashState();
}

class _RouteSplashState extends State<RouteSplash> {
  bool shouldProceed = false;

  _fetchPrefs() async {
    await DatabaseService().setupDB();
    await IGDBService().getReleaseData();
    await DatabaseService().exportDataToJsonFile();

    setState(() {
      shouldProceed = true;//got the prefs; set to some value if needed
    });
  }

  @override
  void initState()  {
    super.initState();
    _fetchPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: shouldProceed
            ? NavigationBar()
            : CircularProgressIndicator(),//show splash screen here instead of progress indicator
      ),
    );
  }
}