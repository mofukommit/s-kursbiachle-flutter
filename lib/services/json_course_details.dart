// To parse this JSON data, do
//
//     final courseDetails = courseDetailsFromJson(jsonString);

import 'dart:convert';

List<CourseDetails> courseDetailsFromJson(String str) => List<CourseDetails>.from(json.decode(str).map((x) => CourseDetails.fromJson(x)));

String courseDetailsToJson(List<CourseDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CourseDetails {
  CourseDetails({
    required this.endDate,
    required this.fname,
    required this.pupilId,
    required this.sname,
    required this.startDate,
  });

  DateTime endDate;
  String fname;
  String pupilId;
  String sname;
  DateTime startDate;

  factory CourseDetails.fromJson(Map<String, dynamic> json) => CourseDetails(
    endDate: DateTime.parse(json["end_date"]),
    fname: json["fname"],
    pupilId: json["pupil_id"],
    sname: json["sname"],
    startDate: DateTime.parse(json["start_date"]),
  );

  Map<String, dynamic> toJson() => {
    "end_date": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "fname": fname,
    "pupil_id": pupilId,
    "sname": sname,
    "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
  };
}
