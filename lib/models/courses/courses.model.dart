// To parse this JSON data, do
//
//     final course = courseFromJson(jsonString);

import 'dart:convert';

Courses coursesFromJson(String str) => Courses.fromJson(json.decode(str));

String coursesToJson(Courses data) => json.encode(data.toJson());

class Courses {
  bool success;
  List<Datum> data;
  String message;

  Courses({
    required this.success,
    required this.data,
    required this.message,
  });

  factory Courses.fromJson(Map<String, dynamic> json) => Courses(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  int id;
  String title;
  String courseCode;
  String description;
  String semester;

  Datum({
    required this.id,
    required this.title,
    required this.courseCode,
    required this.description,
    required this.semester,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        courseCode: json["course_code"],
        description: json["description"],
        semester: json["semester"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "course_code": courseCode,
        "description": description,
        "semester": semester,
      };
}
