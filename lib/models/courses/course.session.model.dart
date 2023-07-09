// To parse this JSON data, do
//
//     final courseSession = courseSessionFromJson(jsonString);

import 'dart:convert';

CourseSessions courseSessionFromJson(String str) =>
    CourseSessions.fromJson(json.decode(str));

String courseSessionToJson(CourseSessions data) => json.encode(data.toJson());

class CourseSessions {
  bool success;
  List<Datumm> data;
  String message;

  CourseSessions({
    required this.success,
    required this.data,
    required this.message,
  });

  factory CourseSessions.fromJson(Map<String, dynamic> json) => CourseSessions(
        success: json["success"],
        data: List<Datumm>.from(json["data"].map((x) => Datumm.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datumm {
  int id;
  String start;
  String end;
  String course;
  String instructor;

  Datumm({
    required this.id,
    required this.start,
    required this.end,
    required this.course,
    required this.instructor,
  });

  factory Datumm.fromJson(Map<String, dynamic> json) => Datumm(
        id: json["id"],
        start: json["start"],
        end: json["end"],
        course: json["course"],
        instructor: json["instructor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start": start,
        "end": end,
        "course": course,
        "instructor": instructor,
      };
}
