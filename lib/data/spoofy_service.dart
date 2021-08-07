import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'models/models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'database_service.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SpoofyService {
  static final SpoofyService _databaseService = SpoofyService._internal();
  final storage = new FlutterSecureStorage();

  factory SpoofyService() {
    return _databaseService;
  }

  SpoofyService._internal();

  Future<int> fetchMusicData() async {
    var artists = await getArtists();
    List<MusicRelease> newReleases = [];
    for (var artist in artists){
      var allReleases = await getReleases(artist);
      newReleases.addAll(allReleases.where((release) => getDayCount(release.releaseDate).abs() < 14));
    }
    final ids = newReleases.map((e) => e.title + e.artist).toSet();
    newReleases.retainWhere((x) => ids.remove(x.title + x.artist));

    print(newReleases);

    var db = DatabaseService();
    await db.deleteAllRecords('musicReleases');

    newReleases.forEach((release) async {
      await db.insertRecord(release, "musicReleases");
    });

    return 0;
  }

  Future<String> getAuthToken() async {
    var storedToken = await storage.read(key: "spoofy_access") ?? "";
    if (storedToken != "" && !storedToken.contains("Bearer") && !storedToken.contains("sanctumv2://")){
      return storedToken;
    }

    var clientID = dotenv.env['SPOOFY_CLIENT_ID'] ?? "";
    var tokenRequestURL = "https://accounts.spotify.com/authorize?client_id=" + clientID +  "&response_type=token&redirect_uri=sanctumv2://spoofyData&scope=user-follow-read";

    // Present the dialog to the user
    final result = await FlutterWebAuth.authenticate(url: tokenRequestURL.toString(), callbackUrlScheme: "sanctumv2");
    var queryParamString = "access_token=";
    var token = result.split("&")[0];
    token = token.substring(token.indexOf(queryParamString) + queryParamString.length, token.length);

    if (token != ""){
      await storage.write(key: "spoofy_access", value: token);
    }
    return token;
  }

  Future<List<Artist>> getArtists() async {
    var token = await getAuthToken();
    var url = "https://api.spotify.com/v1/me/following?type=artist&limit=50";
    var pagination = "";
    bool stop = false;
    List<Artist> artistList = [];

    while (!stop){
      if (artistList.length > 0) {
          pagination = "&after=" + artistList.last.id;
      }

      final response = await http.get(Uri.parse(url + pagination),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + token
          }
      );

      if (response.statusCode == 200){
        var jsonResponse = jsonDecode(response.body);
        List<Artist> newArtists = [];
        for (var artist in jsonResponse['artists']['items']){
          newArtists.add(Artist.fromJson(artist));
        }
        if (newArtists.length == 0){
          stop = true;
        } else {
          artistList.addAll(newArtists);
        }
      } else if (response.statusCode == 401){
        await storage.delete(key: "spoofy_access");
        token = await getAuthToken();
      } else {
        print("Something went wrong with spoofy");
        stop = true;
      }
    }

    return artistList;
  }

  static int getDayCount(int releaseDate){
    var utcDate = DateTime.fromMillisecondsSinceEpoch(releaseDate * 1000).toUtc();
    var currentUtcDate = DateTime.now().toUtc();
    var dayCount = (utcDate.difference(currentUtcDate).inHours / 24).round();
    return dayCount;
  }

  static int getUnixDate(String releaseDate){
    var dateFormat = releaseDate.split("-");
    DateTime date = new DateTime(0);
    DateFormat formatter;
    if (dateFormat.length == 3){
      formatter = DateFormat("yyyy-MM-dd");
      date = formatter.parseLoose(releaseDate, true);
      return date.millisecondsSinceEpoch ~/ 1000;
    } else {
      return 0;
    }
  }

  Future<List<MusicRelease>> getReleases(Artist artist) async {
    var token = await getAuthToken();
    var url = "https://api.spotify.com/v1/artists/" + artist.id + "/albums?include_groups=album,single&country=US&limit=50";
    var pagination = "";
    var offset = 0;
    bool stop = false;
    List<MusicRelease> releaseList = [];

    while (!stop){
      if (releaseList.length > 0 && offset > 0) {
        pagination = "&offset=" + offset.toString();
      }

      final response = await http.get(Uri.parse(url + pagination),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + token
          }
      );

      if (response.statusCode == 200){
        var jsonResponse = jsonDecode(response.body);
        List<MusicRelease> newReleases = [];
        for (var release in jsonResponse['items']){
          newReleases.add(MusicRelease.fromJson(release, artist.name, getUnixDate(release['release_date'].toString())));
        }
        if (newReleases.length == 0){
          stop = true;
        } else {
          offset += newReleases.length;
          releaseList.addAll(newReleases);
        }
      }  else if (response.statusCode == 401){
        await storage.delete(key: "spoofy_access");
        token = await getAuthToken();
      } else {
        print("Something went wrong with spoofy");
        stop = true;
      }
    }

    return releaseList;
  }
}