// fetch data from the internet

import 'dart:convert';

import '../database/teacher_database.dart';
import '../model/teacher.dart';
import 'package:http/http.dart' as http;

class GetAuth {
  Future<Teacher> checkAuthorization() async {

    late KeyDB key;
    key = await KeyDatabase.instance.readKey(1);

    var client = http.Client();

    String username = 'user';
    String password =
        'OxvuA3-@h][DUG1jm0V@@4HQP^aDIoWZRQ&^Iq1t&x#QXw!z)wGsM14p<q2DX5YIbbyVpLK0@-g8-cPoMY#uNaNN*/XRoo4u-^)';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    var uri = Uri.parse('https://' + key.url + '/mobile/v1/teacher_authorized');
    // var uri = Uri.parse('http://192.168.1.55:5000/mobile/v1/get_courses');

    var response = await client.post(uri, headers: <String, String>{
      'costumersecret': key.costumerSec,
      'costumerkey': key.costumerKey,
      'Authorization': basicAuth
    });

    if (response.statusCode == 200) {
      var json = response.body;
      print(response.body);
      Map<String, dynamic> map = jsonDecode(json);
      Teacher teach = Teacher(map['fname'], map['sname']);
      return teach;
    } else {
      throw Exception('Failed to load courses');
    }
  }
}

class Teacher {
  final String fname;
  final String sname;
  Teacher(this.fname, this.sname);
}
