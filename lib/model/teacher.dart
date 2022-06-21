import 'package:skursbiachle/services/scan_qr_get_data.dart';

final String tableTeacher = 'keys';

class KeysFields {

  static final List<String> values = [
    id, costumerKey, costumerSec, url
  ];

  static final String id = 'id';
  static final String costumerKey = 'costumerKey';
  static final String costumerSec = 'costumerSec';
  static final String url = 'url';
}

class KeyDB {
  final int id;
  final String costumerKey;
  final String costumerSec;
  final String url;

  const KeyDB({
    required this.id,
    required this.costumerSec,
    required this.costumerKey,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'costumerKey': costumerKey,
      'costumerSec': costumerSec,
      'url': url,
    };
  }

  KeyDB copy({
    int? id,
    String? costumerKey,
    String? costumerSec,
    String? url,
  }) =>
      KeyDB(
        id: id ?? this.id,
        costumerKey: costumerKey ?? this.costumerKey,
        costumerSec: costumerSec ?? this.costumerSec,
        url: url ?? this.url,
      );

  static KeyDB fromJson(Map<String, Object?> json) => KeyDB(
    id: json[KeysFields.id] as int,
    costumerSec: json[KeysFields.costumerSec] as String,
    costumerKey: json[KeysFields.costumerKey] as String,
    url: json[KeysFields.url] as String,
  );

  Map<String, Object?> toJson() => {
    KeysFields.id: id,
    KeysFields.costumerKey: costumerKey,
    KeysFields.costumerSec: costumerSec,
    KeysFields.url: url,
  };
}


