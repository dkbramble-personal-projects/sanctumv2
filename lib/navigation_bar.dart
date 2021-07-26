import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'screens/screens.dart';


class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _currentIndex = 2;

  final List<Widget> _children = [
    Rumors(),
    Todos(),
    UpcomingReleases(),
    MusicReleases(),
    OngoingShows()
  ];

  void setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        items: [
          TabItem(icon: Icons.help, title: 'Rumors'),
          TabItem(icon: Icons.list, title: 'Todo'),
          TabItem(icon: Icons.calendar_today, title: 'Upcoming' ),
          TabItem(icon: Icons.play_arrow_rounded, title: 'Music'),
          TabItem(icon: Icons.theaters, title: 'Ongoing'),
        ],
        initialActiveIndex: 2,//optional, default as 0
        onTap: (int i) => setIndex(i),
        backgroundColor: Color(0xff14C460),
      )
    );
  }
}