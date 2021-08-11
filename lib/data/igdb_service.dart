import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'models/igdb_release_response_model.dart';
import 'models/models.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'database_service.dart';



class IGDBService {
  static final IGDBService _databaseService = IGDBService._internal();

  factory IGDBService() {
    return _databaseService;
  }

  IGDBService._internal();

  Future<void> getReleaseData() async {
    var authToken = await getAuthToken();
    var clientID = dotenv.env['IGDB_CLIENT_ID'] ?? "";

    var db = new DatabaseService();
    var releases = await db.getReleasesToCheckDate();

    var batchedReleases = [];
    for (var i = 0; i < releases.length; i += 10) {
      batchedReleases.add(releases.sublist(i, i+10 > releases.length ? releases.length : i + 10));
    }

    List<IDGBGameRelease> updatedReleases = [];
    for (var batchedRelease in batchedReleases) {
      updatedReleases.addAll(await pullData(batchedRelease, clientID, authToken));
    }

    var mappedReleases = Map<String, Release>.fromIterable(releases, key: (release) => release.title, value: (release) => release);
    updatedReleases.forEach((updatedRelease) async {
      var recordForDB = mappedReleases[updatedRelease.name];
      if (recordForDB != null){
        var finalUpdate = new Release(
            title: recordForDB.title,
            type: recordForDB.type,
            releaseDate: updatedRelease.firstReleaseDate ?? recordForDB.releaseDate,
            checkDate: recordForDB.checkDate);
        await db.updateRecord(finalUpdate, 'releases');
      }
    });
  }

  Future<List<IDGBGameRelease>> pullData(List<Release> batchedReleases, String clientID, String authToken) async {
    String bodyString = "fields name, first_release_date; where name = (";
    //fields name, first_release_date; where name = ("Twelve Minutes", "The Last Guardian");
    var batchCount = 0;
    batchedReleases.forEach((release) {
      batchCount++;
      bodyString += "\"${release.title}\"";
      if (batchCount != batchedReleases.length){
        bodyString+= ", ";
      }
    });

    bodyString += ");";

    final response = await http.post(Uri.parse('https://api.igdb.com/v4/games'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ' + authToken,
          "Client-ID": clientID
        },
        body: bodyString
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);

      List<IDGBGameRelease> releaseList = [];
      for (var record in jsonResponse){
        releaseList.add(IDGBGameRelease.fromJson(record));
      }

      return releaseList;
    } else {
      throw Exception('Failed to get release dates');
    }
  }

  Future<String> getAuthToken() async {

    var clientID = dotenv.env['IGDB_CLIENT_ID'] ?? "";
    var clientSecret = dotenv.env['IGDB_CLIENT_SECRET'] ?? "";
    var tokenRequestURL = 'https://id.twitch.tv/oauth2/token?client_id=' + clientID + '&client_secret=' + clientSecret + '&grant_type=client_credentials';
    final response = await http.post(Uri.parse(tokenRequestURL));
    if (response.statusCode == 200) {
      Map<String, dynamic> authTokenResponse = jsonDecode(response.body);
      return authTokenResponse['access_token'];
    } else {
      throw Exception('Failed to get auth token for IGDB');
    }
  }

}