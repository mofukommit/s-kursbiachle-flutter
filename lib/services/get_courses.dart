// fetch data from the internet

import 'dart:convert';

import '../database/teacher_database.dart';
import '../model/teacher.dart';
import 'json_courses.dart';
import 'package:http/http.dart' as http;

class GetCourses {
  Future<List<Courses>?> getPosts() async {
    late KeyDB key;
    key = await KeyDatabase.instance.readKey(1);

    var client = http.Client();

    String username = 'user';
    String password = 'OxvuA3-@h][DUG1jm0V@@4HQP^aDIoWZRQ&^Iq1t&x#QXw!z)wGsM14p<q2DX5YIbbyVpLK0@-g8-cPoMY#uNaNN*/XRoo4u-^)';
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    var uri = Uri.parse('https://' + key.url + '/mobile/v1/get_courses');
    // var uri = Uri.parse('http://192.168.1.55:5000/mobile/v1/get_courses');

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
      return coursesFromJson(json);
    } else {
      throw Exception('Failed to load courses');
    }
  }
}