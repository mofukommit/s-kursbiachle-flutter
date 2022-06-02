import 'dart:convert';

getID(String? valueQR){
  try {
    Map<String, dynamic> map = jsonDecode(valueQR!);
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
  final String pupilID;
  GetPupilID(this.type, this.pupilID);
}

class KeyCreation {
  final String type;
  final String costumerKey;
  final String costumerSec;
  KeyCreation(this.type, this.costumerSec, this.costumerKey);
}

class ErrorNEW {
  final String msg;
  final int code;
  ErrorNEW(this.msg, this.code);
}
