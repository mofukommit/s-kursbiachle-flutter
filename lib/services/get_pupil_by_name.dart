// fetch data from the internet

import 'package:http/http.dart' as http;
import 'json_pupil_name.dart';

class GetPupils {
  Future<List<Pupilsearch>?> getPosts(String fname, String sname) async {
    var client = http.Client();

    if (fname == null || fname == '') {
      fname = 'none';
    }
    if (sname == null || sname == '') {
      sname = 'none';
    }

    var req_uri = '${fname}/${sname}';
    var urlRoute = 'http://192.168.1.55:5000/mobile/v1/get_pupil_search_mobile/';
    var uri = Uri.parse('${urlRoute}${req_uri}');


    var response = await client.get(uri, headers: {
      'costumersecret': '084c54973915da091b12986a3b685fba563c139f2d33db4dd8af293ab91f7be02e8d4b6bb69134f35973d28dd2de9d8e99014d16fbc00ded1c7257044e10046a',
      'costumerkey': 'd5df95842c16f1fc6324bbce7f93a40aeee0ad8e9af86ad07b061f26f6ac023e'
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