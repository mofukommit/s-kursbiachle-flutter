// To parse this JSON data, do
//
//     final pupil = pupilFromJson(jsonString);

import 'dart:convert';

Pupil pupilFromJson(String str) => Pupil.fromJson(json.decode(str));

String pupilToJson(Pupil data) => json.encode(data.toJson());

class Pupil {
  Pupil({
    required this.pId,
    required this.fname,
    required this.sname,
    required this.age,
    this.tel,
    this.prefTeach,
    required this.level,
    required this.courses,
    required this.addr,
  });

  String pId;
  String fname;
  String sname;
  int age;
  String? tel;
  dynamic prefTeach;
  dynamic level;
  List<Course> courses;
  List<Addr> addr;

  factory Pupil.fromJson(Map<String, dynamic> json) => Pupil(
    pId: json["p_id"],
    fname: json["fname"],
    sname: json["sname"],
    age: int.parse(json["age"]),
    tel: json["tel"],
    prefTeach: json["pref_teach"],
    level: json["level"],
    courses: List<Course>.from(json["courses"].map((x) => Course.fromJson(x))),
    addr: List<Addr>.from(json["addr"].map((x) => Addr.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "p_id": pId,
    "fname": fname,
    "sname": sname,
    "age": age,
    "tel": tel,
    "pref_teach": prefTeach,
    "level": level,
    "courses": List<dynamic>.from(courses.map((x) => x.toJson())),
    "addr": List<dynamic>.from(addr.map((x) => x.toJson())),
  };
}

class Addr {
  Addr({
    this.street,
    this.housenr,
    this.city,
    this.plz,
    this.country,
    this.reFname,
    this.reSname,
  });

  String? street;
  String? housenr;
  String? city;
  String? plz;
  String? country;
  String? reFname;
  String? reSname;

  factory Addr.fromJson(Map<String, dynamic> json) => Addr(
    street: json["street"],
    housenr: json["housenr"],
    city: json["city"],
    plz: json["plz"],
    country: json["country"],
    reFname: json["re_fname"],
    reSname: json["re_sname"],
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "housenr": housenr,
    "city": city,
    "plz": plz,
    "country": country,
    "re_fname": reFname,
    "re_sname": reSname,
  };
}

class Course {
  Course({
    this.courseId,
    this.groupId,
    this.courseDays,
    required this.startDate,
    this.privHours,
  });

  String? courseId;
  String? groupId;
  int? courseDays;
  DateTime startDate;
  dynamic privHours;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    courseId: json["course_id"],
    groupId: json["group_id"],
    courseDays: json["course_days"],
    startDate: DateTime.parse(json["start_date"]),
    privHours: json["priv_hours"],
  );

  Map<String, dynamic> toJson() => {
    "course_id": courseId,
    "group_id": groupId,
    "course_days": courseDays,
    "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "priv_hours": privHours,
  };
}
