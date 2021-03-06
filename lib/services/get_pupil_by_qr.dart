// fetch data from the internet

import 'dart:convert';

import 'package:http/http.dart' as http;
import '../database/teacher_database.dart';
import '../model/teacher.dart';
import 'json_pupil_qr.dart';

class GetPupil {
  Future<Pupil> getPupil(String? pupilID) async {
    late KeyDB key;
    key = await KeyDatabase.instance.readKey(1);

    var client = http.Client();

    String username = 'user';
    String password = 'OxvuA3-@h][DUG1jm0V@@4HQP^aDIoWZRQ&^Iq1t&x#QXw!z)wGsM14p<q2DX5YIbbyVpLK0@-g8-cPoMY#uNaNN*/XRoo4u-^)';
    print(password);
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    var urlRoute = 'https://' + key.url + '/mobile/v1/get_pupil_mobile/';
    // var urlRoute = 'http://192.168.1.55:5000/mobile/v1/get_pupil_mobile/';

    var url = urlRoute + pupilID!;

    var uri = Uri.parse(url);

    var response = await client.get(uri, headers: <String, String>{
      'costumersecret':
      key.costumerSec,
      'costumerkey':
      key.costumerKey,
      'Authorization': basicAuth
    });

    print(response.body);

    if (response.statusCode == 200) {
      var json = response.body;
      return pupilFromJson(json);
    } else {
      throw Exception('Failed to load pupil');
    }

  }
}


