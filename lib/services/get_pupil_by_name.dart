// fetch data from the internet

import 'package:http/http.dart' as http;
import '../database/teacher_database.dart';
import '../model/teacher.dart';
import 'json_pupil_name.dart';

class GetPupils {
  Future<List<Pupilsearch>?> getPosts(String fname, String sname) async {
    late KeyDB key;
    key = await KeyDatabase.instance.readKey(1);

    var client = http.Client();

    if (fname == null || fname == '') {
      fname = 'none';
    }
    if (sname == null || sname == '') {
      sname = 'none';
    }

    var req_uri = '${fname}/${sname}';
    var urlRoute = 'http://' + key.url + '/mobile/v1/get_pupil_search_mobile/';
    // var urlRoute = 'http://192.168.1.55:5000/mobile/v1/get_pupil_search_mobile/';
    var uri = Uri.parse('${urlRoute}${req_uri}');


    var response = await client.get(uri, headers: {
      'costumersecret': key.costumerSec,
      'costumerkey': key.costumerKey
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