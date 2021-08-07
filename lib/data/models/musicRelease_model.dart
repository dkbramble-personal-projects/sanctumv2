import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../spoofy_service.dart';
import 'IDBModel.dart';

class MusicRelease implements IDBModel {
  @override
  final String artist;
  final String title;
  final String type;
  final int releaseDate;

  MusicRelease({
    required this.artist,
    required this.title,
    required this.type,
    required this.releaseDate,
  });

  @override
  Map<String, int> getColumnHeaders() {
    return {"Title":3, "Artist":2, "Type":1, "Date": 1};
  }

  @override
  List<Expanded> getTableRowValues(Color rowColor, BuildContext context, VoidCallback callback) {

    var date = DateTime.fromMillisecondsSinceEpoch(this.releaseDate * 1000).toUtc();

    return [
      Expanded(flex:3, child: Container(color: rowColor, padding: EdgeInsets.symmetric(vertical: 15), child: Text(this.title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, )))),
      Expanded(flex:2, child: Container(color: rowColor, padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5), child: Text(this.artist, textAlign: TextAlign.center, style: TextStyle(color: Colors.white)))),
      Expanded(flex:1, child: Container(color: rowColor, padding: EdgeInsets.symmetric(vertical: 15), child: Text(this.type, textAlign: TextAlign.center, style: TextStyle(color: Colors.white)))),
      Expanded(flex:1, child: Container(color: rowColor, padding: EdgeInsets.symmetric(vertical: 15), child: Text(date.month.toString() + "/" + date.day.toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white)))),
    ];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'releaseDate': releaseDate,
      'artist': artist
    };
  }

  MusicRelease.fromJson(Map<String, dynamic> json, String artistName, int dayCount)
      : title = json['name'],
        releaseDate = dayCount,
        type = json['album_type'],
        artist = artistName;
}