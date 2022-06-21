// To parse this JSON data, do
//
//     final pupilsearch = pupilsearchFromJson(jsonString);

import 'dart:convert';

List<Pupilsearch> pupilsearchFromJson(String str) => List<Pupilsearch>.from(json.decode(str).map((x) => Pupilsearch.fromJson(x)));

String pupilsearchToJson(List<Pupilsearch> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pupilsearch {
  Pupilsearch({
    this.age,
    required this.fname,
    this.pupilId,
    required this.sname,
  });

  int? age;
  String fname;
  String? pupilId;
  String sname;

  factory Pupilsearch.fromJson(Map<String, dynamic> json) => Pupilsearch(
    age: int.parse(json["age"]),
    fname: json["fname"],
    pupilId: json["pupil_id"],
    sname: json["sname"],
  );

  Map<String, dynamic> toJson() => {
    "age": age,
    "fname": fname,
    "pupil_id": pupilId,
    "sname": sname,
  };
}
