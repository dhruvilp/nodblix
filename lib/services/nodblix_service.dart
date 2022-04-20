import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../defaults.dart';

var client = http.Client();
final kHeader = {
  'Content-Type': 'application/json',
  'X-Requested-With': 'XMLHttpRequest'
};

final kPortGui = dotenv.env['PORT_GUI'];
final kTokenSecret = dotenv.env['TOKEN_SECRET'];

class HttpService {
  static Future<T?> getJson<T>(String kPath, Map<String, String> kHeaders) {
    return http
        .get(Uri.parse('$CORS_PROXY$GRAPH_API_URL$kPath'), headers: kHeaders)
        .then((response) {
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as T;
      }
      print('Status code from getJson: ${response.statusCode}...');
      return null;
    }).catchError((err) => print('Error from getJson: $err'));
  }

  static Future<T?> getWikiJson<T>(String title) {
    return http
        .get(Uri.parse(
            'https://en.wikipedia.org/w/api.php?action=query&formatversion=2&prop=pageimages%7Cpageterms%7Cextracts&titles=$title&format=json&explaintext=&exchars=1000'))
        .then((response) {
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as T;
      }
      print('Status code from getWikiJson: ${response.statusCode}...');
      return null;
    }).catchError((err) => print('Error from getWikiJson: $err'));
  }

  static Future<T?> postJson<T>(
      String kPath, Map<String, String> kHeaders, dynamic reqBody) {
    var encodedReqBody = jsonEncode(reqBody);
    return http
        .post(Uri.parse('$CORS_PROXY$GRAPH_API_URL$kPath'),
            headers: kHeaders, body: encodedReqBody)
        .then((response) {
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as T;
      }
      print('Status code from postJson: ${response.statusCode}...');
      return null;
    }).catchError((err) => print('Error from getJson: $err'));
  }
}

class NodblixService {
  static Future<Map<String, dynamic>?> fetchEcho() async {
    Map<String, dynamic>? respMsg;
    await HttpService.getJson<Map<String, dynamic>>('/echo', kHeader)
        .then((response) {
      respMsg = !response!['error'] ? response : null;
    }).whenComplete(() => print('Fetching echo done!....'));
    return respMsg;
  }

  static Future<Map<String, dynamic>?> fetchWikiData(String title) async {
    Map<String, dynamic>? wikiInfo;
    await HttpService.getWikiJson<Map<String, dynamic>>(title).then((response) {
      wikiInfo = response!['batchcomplete'] ? response : null;
    }).whenComplete(() => print('Fetching wiki info done!....'));
    return wikiInfo;
  }

  // HttpHeaders.authorizationHeader: 'Bearer API_TOKEN'
  static Future<Map<String, dynamic>?> fetchRequestToken() async {
    Map<String, dynamic>? tokenResp;
    await HttpService.postJson<Map<String, dynamic>>('/requesttoken', kHeader, {
      "secret": kTokenSecret,
      "graph": GRAPH_NAME,
      "lifetime": TOKEN_LIFETIME
    }).then((response) {
      tokenResp = !response!['error'] ? response : null;
    }).whenComplete(() => print('Fetching request token done!....'));
    return tokenResp;
  }

  static Future<Map<String, dynamic>?> fetchVerticesByCondition(
      String condition, String token) async {
    Map<String, dynamic>? respMsg;
    await HttpService.getJson<Map<String, dynamic>>(
      '/graph/$GRAPH_NAME/edges/condition/$condition/associated_with_a/compound_a',
      {
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    ).then((response) {
      respMsg = !response!['error'] ? response : null;
    }).whenComplete(() => print('Fetching vertices by condition is done!....'));
    return respMsg;
  }

  static Future<Map<String, dynamic>?> fetchVerticesByCompound(
      String compound, String token) async {
    Map<String, dynamic>? respMsg;
    await HttpService.getJson<Map<String, dynamic>>(
      '/graph/$GRAPH_NAME/edges/compound_a/$compound/associated_with_a/condition',
      {
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    ).then((response) {
      respMsg = !response!['error'] ? response : null;
    }).whenComplete(() => print('Fetching vertices by compound is done!....'));
    return respMsg;
  }
}

//========================

void main() {
  print('try something here');
}
