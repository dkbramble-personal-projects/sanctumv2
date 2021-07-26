import 'package:flutter/material.dart';
import 'navigation_bar.dart';
import 'data/database_service.dart';

class RouteSplash extends StatefulWidget {
  @override
  _RouteSplashState createState() => _RouteSplashState();
}

class _RouteSplashState extends State<RouteSplash> {
  bool shouldProceed = false;

  _fetchPrefs() async {
    // await Future.delayed(Duration(seconds: 20));// dummy code showing the wait period while getting the preferences
    var databaseService = DatabaseService();
    await databaseService.setupDB();
    setState(() {
      shouldProceed = true;//got the prefs; set to some value if needed
    });
  }

  @override
  void initState()  {
    super.initState();
    _fetchPrefs();//running initialisation code; getting prefs etc.
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