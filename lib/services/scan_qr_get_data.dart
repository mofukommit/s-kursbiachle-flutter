import 'dart:convert';

import '../database/teacher_database.dart';
import '../model/teacher.dart';

getID(String? valueQR) async {
  try {
    Map<String, dynamic> map = jsonDecode(valueQR!);
    if (map['type'] == 'pupil') {
      return GetPupilID(map['type'], map['data']['pupil_id']);
    } else if (map['type'] == 'key') {
      try {
        late KeyDB key;
        key = await KeyDatabase.instance.readKey(1);
        if (key.costumerKey != map['data']['costumerkey']) {
          KeyDatabase.instance.delete(1);
          return KeyCreation(map['type'], map['data']['costumersecret'],
              map['data']['costumerkey'], map['data']['url']);
        }else{
          /* TEST */
          if (key.url != map['data']['url']){
            KeyDatabase.instance.delete(1);
            return KeyCreation(map['type'], map['data']['costumersecret'],
                map['data']['costumerkey'], map['data']['url']);
          }
          return KeyCreation(map['type'], map['data']['costumersecret'],
              map['data']['costumerkey'], map['data']['url']);
          // return ErrorNEW('GIBTS SCHON', 782139);
        }
      } on Exception catch (e) {
        print(e);
        return KeyCreation(map['type'], map['data']['costumersecret'],
            map['data']['costumerkey'],  map['data']['url']);
      }
    }
  } on Exception catch (e) {
    print(e);
    return ErrorNEW('Not a common QR-Code', 3);
  }
}

// Pupil
class GetPupilID {
  final String type;
  final String pupilID;
  GetPupilID(this.type, this.pupilID);
}

// KeyCreation
class KeyCreation {
  final String type;
  final String costumerKey;
  final String costumerSec;
  final String url;
  KeyCreation(this.type, this.costumerSec, this.costumerKey, this.url);
}


// Error
class ErrorNEW {
  final String msg;
  final int code;
  ErrorNEW(this.msg, this.code);
}
