import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skursbiachle/services/scan_qr_get_data.dart';

final String tableCourses = 'courses';

class CoursesFields {

  static final List<String> values = [
    id, groupId, courseId, startTime, gName, amountPupils, amPm, courseDate, colorCode
  ];

  static final String id = '';
  static final String amountPupils = '';
  static final String courseDate = '';
  static final String gName = '';
  static final String groupId = '';
  static final String startTime = '';
  static final String courseId = '';
  static final String colorCode = '';
  static final String amPm = '';

}

class CourseDB {
  final int id;
  final int amountPupils;
  final DateTime courseDate;
  final String gName;
  final String groupId;
  final String startTime;
  final String courseId;
  final String colorCode;
  final String amPm;

  const CourseDB({
    required this.id,
    required this.amountPupils,
    required this.courseDate,
    required this.gName,
    required this.groupId,
    required this.startTime,
    required this.courseId,
    required this.colorCode,
    required this.amPm,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amountPupils': amountPupils.toString(),
      'courseDate': courseDate.toString(),
      'gName': gName,
      'groupId': groupId,
      'startTime': startTime,
      'courseId': courseId,
      'colorCode': colorCode,
      'amPm': amPm
    };
  }

  CourseDB copy({
    int? amountPupils,
    DateTime? courseDate,
    String? gName,
    String? groupId,
    String? startTime,
    String? courseId,
    String? colorCode,
    String? amPm,
    int? id,
  }) =>
      CourseDB(
        amountPupils: amountPupils ?? this.amountPupils,
        courseDate: courseDate ?? this.courseDate,
        gName: gName ?? this.gName,
        groupId: groupId ?? this.groupId,
        startTime: startTime ?? this.startTime,
        courseId: courseId ?? this.courseId,
        colorCode: colorCode ?? this.colorCode,
        amPm: amPm ?? this.amPm,
        id: id ?? this.id
      );

  static CourseDB fromJson(Map<String, Object?> json) => CourseDB(
    amountPupils: json[CoursesFields.amountPupils] as int,
    courseDate: json[CoursesFields.courseDate] as DateTime,
    gName: json[CoursesFields.gName] as String,
    groupId: json[CoursesFields.groupId] as String,
    startTime: json[CoursesFields.startTime] as String,
    courseId: json[CoursesFields.courseId] as String,
    colorCode: json[CoursesFields.colorCode] as String,
    amPm: json[CoursesFields.amPm] as String,
    id: json[CoursesFields.id] as int,
  );

  Map<String, Object?> toJson() =>
      {
        CoursesFields.id: id,
        CoursesFields.amountPupils: amountPupils,
        CoursesFields.courseDate: '${courseDate.year.toString().padLeft(4, '0')}-${courseDate.month.toString().padLeft(2, '0')}-${courseDate.day.toString().padLeft(2, '0')}',
        CoursesFields.gName: gName,
        CoursesFields.groupId: groupId,
        CoursesFields.startTime: startTime,
        CoursesFields.courseId: courseId,
        CoursesFields.colorCode: colorCode,
        CoursesFields.amPm: amPm
      };
}


