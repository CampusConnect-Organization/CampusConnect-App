// To parse this JSON data, do
//
//     final courseEnrollments = courseEnrollmentsFromJson(jsonString);

import 'dart:convert';

CourseEnrollments courseEnrollmentsFromJson(String str) =>
    CourseEnrollments.fromJson(json.decode(str));

String courseEnrollmentsToJson(CourseEnrollments data) =>
    json.encode(data.toJson());

class CourseEnrollments {
  bool success;
  List<Datummm> data;
  String message;

  CourseEnrollments({
    required this.success,
    required this.data,
    required this.message,
  });

  factory CourseEnrollments.fromJson(Map<String, dynamic> json) =>
      CourseEnrollments(
        success: json["success"],
        data: List<Datummm>.from(json["data"].map((x) => Datummm.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datummm {
  int id;
  String course;
  String semester;
  String courseCode;

  Datummm(
      {required this.id,
      required this.course,
      required this.semester,
      required this.courseCode});

  factory Datummm.fromJson(Map<String, dynamic> json) => Datummm(
      id: json["id"],
      course: json["course"],
      semester: json["semester"],
      courseCode: json["course_code"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "course": course,
        "semester": semester,
        "course_code": courseCode
      };
}
