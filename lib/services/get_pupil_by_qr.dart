// fetch data from the internet

import 'package:http/http.dart' as http;
import '../database/teacher_database.dart';
import '../model/teacher.dart';
import 'json_pupil_qr.dart';

class GetPupil {
  Future<Pupil> getPupil(String? pupilID) async {
    late KeyDB key;
    key = await KeyDatabase.instance.readKey(1);

    var client = http.Client();

    var urlRoute = 'http://' + key.url + '/mobile/v1/get_pupil_mobile/';
    // var urlRoute = 'http://192.168.1.55:5000/mobile/v1/get_pupil_mobile/';

    var url = urlRoute + pupilID!;

    var uri = Uri.parse(url);

    var response = await client.get(uri, headers: {
      'costumersecret':
          key.costumerSec,
      'costumerkey':
          key.costumerKey
    });
    print(response.body);

    if (response.statusCode == 200) {
      var json = response.body;
      return pupilFromJson(json);
    } else {
      throw Exception('Failed to load pupil');
    }

  }
}


