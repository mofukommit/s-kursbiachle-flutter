// fetch data from the internet

import 'package:http/http.dart' as http;

class GetPupil {
  getPupil(String pupil_id) async {
    var client = http.Client();

    var urlRoute = 'http://192.168.2.92:5000/mobile/v1/get_pupil_mobile/';
    var url = urlRoute + pupil_id;

    var uri = Uri.parse(url);

    var response = await client.get(uri, headers: {
      'costumersecret':
          '084c54973915da091b12986a3b685fba563c139f2d33db4dd8af293ab91f7be02e8d4b6bb69134f35973d28dd2de9d8e99014d16fbc00ded1c7257044e10046a',
      'costumerkey':
          'd5df95842c16f1fc6324bbce7f93a40aeee0ad8e9af86ad07b061f26f6ac023e'
    });
    print(response.body);

    if (response.statusCode == 200) {
      return response.body;
    }
  }
}
