import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:skursbiachle/database/courses_database.dart';
import 'package:skursbiachle/model/courses.dart';
import '../database/teacher_database.dart';
import '../model/teacher.dart';
import 'json_pupil_name.dart';
import '../extensions/write_files.dart';

class DailyClosure {
  writeDataToFile(CourseDB course) async {
    var data = {
      'build_id': course.courseId,
      'course_date': DateFormat('dd.MM.yyyy').format(course.courseDate),
    };

    Communication().writeCommunication(data);
  }

  Future<List<Pupilsearch>?> getSearchResults(String fname, String sname) async {
    late KeyDB key;
    key = await KeyDatabase.instance.readKey(1);

    var client = http.Client();

    if (fname == null || fname == '') {
      fname = 'none';
    }
    if (sname == null || sname == '') {
      sname = 'none';
    }

    String username = 'user';
    String password = 'OxvuA3-@h][DUG1jm0V@@4HQP^aDIoWZRQ&^Iq1t&x#QXw!z)wGsM14p<q2DX5YIbbyVpLK0@-g8-cPoMY#uNaNN*/XRoo4u-^)';
    print(password);
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    var urlRoute = 'https://${key.url}/mobile/v1/get_pupil_search_mobile/${fname}/${sname}';
    // var urlRoute = 'http://192.168.1.55:5000/mobile/v1/get_pupil_search_mobile/';
    var uri = Uri.parse(urlRoute);


    var response = await client.get(uri, headers: <String, String>{
      'costumersecret':
      key.costumerSec,
      'costumerkey':
      key.costumerKey,
      'Authorization': basicAuth
    });

    print('PUPILS REQUEST ${response.body}');

    if (response.statusCode == 200) {
      var json = response.body;
      return pupilsearchFromJson(json);
    } else {
      throw Exception('Failed to load courses');
    }
  }
}