// fetch data from the internet

import 'dart:convert';

import '../database/teacher_database.dart';
import '../model/teacher.dart';
import 'json_course_details.dart';
import 'json_courses.dart';
import 'package:http/http.dart' as http;

class PostNewPupilActiveCourse {
  postPupil(String? pupilId) async {
    late KeyDB key;
    key = await KeyDatabase.instance.readKey(1);

    var client = http.Client();

    String username = 'user';
    String password = 'OxvuA3-@h][DUG1jm0V@@4HQP^aDIoWZRQ&^Iq1t&x#QXw!z)wGsM14p<q2DX5YIbbyVpLK0@-g8-cPoMY#uNaNN*/XRoo4u-^)';
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    var uri = Uri.parse('https://${key.url}/mobile/v1/pupil_to_my_course/$pupilId');

    var response = await client.post(uri, headers: <String, String>{
      'costumersecret':
      key.costumerSec,
      'costumerkey':
      key.costumerKey,
      'Authorization': basicAuth
    });

    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      print(response.body);
      return false;
    }
  }
}