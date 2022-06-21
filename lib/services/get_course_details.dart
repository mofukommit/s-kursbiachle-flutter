// fetch data from the internet

import 'dart:convert';

import '../database/teacher_database.dart';
import '../model/teacher.dart';
import 'json_course_details.dart';
import 'json_courses.dart';
import 'package:http/http.dart' as http;

class GetCourseDetails {
  Future<List<CourseDetails>?> getDetails(String courseId) async {
    late KeyDB key;
    key = await KeyDatabase.instance.readKey(1);

    var client = http.Client();

    String username = 'user';
    String password = 'OxvuA3-@h][DUG1jm0V@@4HQP^aDIoWZRQ&^Iq1t&x#QXw!z)wGsM14p<q2DX5YIbbyVpLK0@-g8-cPoMY#uNaNN*/XRoo4u-^)';
    print(password);
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    var uri = Uri.parse('https://' + key.url + '/mobile/v1/detail_course/' + courseId);

    var response = await client.get(uri, headers: <String, String>{
      'costumersecret':
      key.costumerSec,
      'costumerkey':
      key.costumerKey,
      'Authorization': basicAuth
    });

    if (response.statusCode == 200) {
      var json = response.body;
      return courseDetailsFromJson(json);
    } else {
      throw Exception('Failed to load courses');
    }
  }
}