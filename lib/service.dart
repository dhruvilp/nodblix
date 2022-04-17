import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as Http;

var client = Http.Client();
final kHeader = {'Content-Type': 'application/json'};

class NodblixHttpClient {
  static final kAppUrl = dotenv.env['APP_URL'];
  static final kProtocol = dotenv.env['PROTOCOL'];
  static final kPort = dotenv.env['PORT'];
  static final kGraphName = dotenv.env['GRAPH_NAME'];
  static final kTokenLifetime = dotenv.env['TOKEN_LIFETIME'];
  static final kPortGui = dotenv.env['PORT_GUI'];

  static Future<Http.Response> get(String endpoint) {
    return client
        .get(Uri.parse('$kProtocol://$kAppUrl:$kPort$endpoint'))
        .timeout(const Duration(seconds: 30))
        .catchError((err) {
      if (kDebugMode) print('Error [GET] : $err');
    });
  }

  static Future<Http.Response> post(String endpoint, dynamic kBody) async {
    var encodedBody = jsonEncode(kBody);
    var response = await client
        .post(Uri.parse('$kProtocol://$kAppUrl:$kPort$endpoint'),
            headers: kHeader, body: encodedBody)
        .timeout(const Duration(seconds: 30))
        .catchError((err) {
      if (kDebugMode) print('Error [POST] : $err');
    });
    return jsonDecode(response.body);
  }
}

class NodblixService {
  // ==== ECHO to check if graph instance is ALIVE
  Future<dynamic> echo() async {
    var response = await NodblixHttpClient.get('/echo');
    return json.decode(response.body);
  }
}
