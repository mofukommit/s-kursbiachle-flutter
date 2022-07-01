import 'package:skursbiachle/services/scan_qr_get_data.dart';

final String tableDaily = 'dailyclosing';

class DailyFields {

  static final List<String> values = [
    id, buildId, courseDate, gId
  ];

  static final String id = 'id';
  static final String buildId = 'buildId';
  static final String courseDate = 'courseDate';
  static final String gId = 'gId';
}

class DailyDB {
  final int id;
  final String buildId;
  final DateTime courseDate;
  final String gId;

  const DailyDB({
    required this.id,
    required this.buildId,
    required this.courseDate,
    required this.gId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buildId': buildId,
      'courseDate': courseDate.toString(),
      'gId': gId,
    };
  }

  DailyDB copy({
    int? id,
    String? buildId,
    DateTime? courseDate,
    String? gId,
  }) =>
      DailyDB(
        id: id ?? this.id,
        buildId: buildId ?? this.buildId,
        courseDate: courseDate ?? this.courseDate,
        gId: gId ?? this.gId,
      );

  static DailyDB fromJson(Map<String, Object?> json) => DailyDB(
    id: json[DailyFields.id] as int,
    buildId: json[DailyFields.buildId] as String,
    courseDate: json[DailyFields.courseDate] as DateTime,
    gId: json[DailyFields.gId] as String,
  );

  Map<String, Object?> toJson() => {
    DailyFields.id: id,
    DailyFields.buildId: buildId,
    DailyFields.courseDate: '${courseDate.year.toString().padLeft(4, '0')}-${courseDate.month.toString().padLeft(2, '0')}-${courseDate.day.toString().padLeft(2, '0')}',
    DailyFields.gId: gId,
  };
}


