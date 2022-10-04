import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:find_track_app/secret/tokens.dart';
import 'package:http/http.dart';

class AudD_API {
  static final AudD_API _singleton = AudD_API._internal();

  factory AudD_API() {
    return _singleton;
  }

  Future<Response> postRequestAudD(String sampleFile) async {
    var url = Uri.https('api.audd.io', '/');
    final API_TOKEN = API_AUDD_TOKEN;

    Map<String, dynamic> data = {
      "api_token": "${API_TOKEN}",
      "audio": sampleFile,
      "method": "recognize",
      "return": 'apple_music,spotify'
    };
    var response = await http.post(url,
        headers: {
          'Content-Type': 'multipart/form-data',
        },
        body: jsonEncode(data));
    print(response.body);
    return response;
  }

  AudD_API._internal();
}
