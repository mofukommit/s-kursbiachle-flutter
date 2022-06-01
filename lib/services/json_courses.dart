// Mapping
//
// To parse this JSON data, do
//     final courses = coursesFromJson(jsonString);

import 'dart:convert';

List<Courses> coursesFromJson(String str) => List<Courses>.from(json.decode(str).map((x) => Courses.fromJson(x)));

String coursesToJson(List<Courses> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Courses {
  Courses({
    required this.amountPupils,
    required this.courseDate,
    required this.gName,
    required this.groupId,
    required this.startTime,
  });

  int amountPupils;
  DateTime courseDate;
  String gName;
  String groupId;
  String startTime;

  factory Courses.fromJson(Map<String, dynamic> json) => Courses(
    amountPupils: json["amount_pupils"],
    courseDate: DateTime.parse(json["course_date"]),
    gName: json["g_name"],
    groupId: json["group_id"],
    startTime: json["start_time"],
  );

  Map<String, dynamic> toJson() => {
    "amount_pupils": amountPupils,
    "course_date": "${courseDate.year.toString().padLeft(4, '0')}-${courseDate.month.toString().padLeft(2, '0')}-${courseDate.day.toString().padLeft(2, '0')}",
    "g_name": gName,
    "group_id": groupId,
    "start_time": startTime,
  };
}