// fetch data from the internet

import 'dart:convert';

import '../../../database/teacher_database.dart';
import '../../../model/teacher.dart';

import 'package:http/http.dart' as http;

class Available_Requestes {
  Future<bool> postNewDates(Map<String, String> body) async {
    // late KeyDB key;
     // key = await KeyDatabase.instance.readKey(1);

    var client = http.Client();

    String username = 'user';
    String password =
        'OxvuA3-@h][DUG1jm0V@@4HQP^aDIoWZRQ&^Iq1t&x#QXw!z)wGsM14p<q2DX5YIbbyVpLK0@-g8-cPoMY#uNaNN*/XRoo4u-^)';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    var uri = Uri.parse(
        'https://192.168.2.147:4899/mobile/v1/teacher_available');

    var response = await client.post(uri, headers: <String, String>{
      // 'costumersecret': key.costumerSec,
      // 'costumerkey': key.costumerKey,
      // 'Authorization': basicAuth
    },
    body: body
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load courses');
    }
  }
}
