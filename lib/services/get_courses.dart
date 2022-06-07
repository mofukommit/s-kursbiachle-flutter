// fetch data from the internet

import 'json_courses.dart';
import 'package:http/http.dart' as http;

class GetCourses {
  Future<List<Courses>?> getPosts() async {
    var client = http.Client();

    var uri = Uri.parse('http://192.168.2.92:5000/mobile/v1/get_courses');
    // var uri = Uri.parse('http://192.168.2.92:5000/mobile/v1/get_courses');

    var response = await client.get(uri, headers: {
      'costumersecret':
          '084c54973915da091b12986a3b685fba563c139f2d33db4dd8af293ab91f7be02e8d4b6bb69134f35973d28dd2de9d8e99014d16fbc00ded1c7257044e10046a',
      'costumerkey':
          'd5df95842c16f1fc6324bbce7f93a40aeee0ad8e9af86ad07b061f26f6ac023e'
    });
    print(response.body);

    if (response.statusCode == 200) {
      var json = response.body;
      return coursesFromJson(json);
    }
  }
}