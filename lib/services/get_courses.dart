// fetch data from the internet

import '../database/teacher_database.dart';
import '../model/teacher.dart';
import 'json_courses.dart';
import 'package:http/http.dart' as http;

class GetCourses {
  Future<List<Courses>?> getPosts() async {
    late KeyDB key;
    key = await KeyDatabase.instance.readKey(1);

    var client = http.Client();



    var uri = Uri.parse('http://' + key.url + '/mobile/v1/get_courses');
    // var uri = Uri.parse('http://192.168.1.55:5000/mobile/v1/get_courses');

    var response = await client.get(uri, headers: {
      'costumersecret':
      key.costumerSec,
      'costumerkey':
      key.costumerKey
    });
    // print(response.body);

    if (response.statusCode == 200) {
      var json = response.body;
      return coursesFromJson(json);
    } else {
      throw Exception('Failed to load courses');
    }
  }
}