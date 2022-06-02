import 'dart:convert';

get_ID(String? value_qr){
  try {
    Map<String, dynamic> map = jsonDecode(value_qr!);
    if (map['type'] == 'pupil') {
      return GetPupilID(map['type'], map['data']['pupil_id']);
    } else if (map['type'] == 'key') {
      return KeyCreation(map['type'], map['data']['costumersecret'],
          map['data']['costumerkey']);
    }
  } on Exception catch (_) {
    return ErrorNEW('Not a common QR-Code', 3);
  }
}

class GetPupilID {
  final String type;
  final String pupil_id;
  GetPupilID(this.type, this.pupil_id);
}

class KeyCreation {
  final String type;
  final String costumerkey;
  final String costumersec;
  KeyCreation(this.type, this.costumersec, this.costumerkey);
}

class ErrorNEW {
  final String msg;
  final int code;
  ErrorNEW(this.msg, this.code);
}
