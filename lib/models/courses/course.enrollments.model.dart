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
  List<Datummmm> data;
  String message;

  CourseEnrollments({
    required this.success,
    required this.data,
    required this.message,
  });

  factory CourseEnrollments.fromJson(Map<String, dynamic> json) =>
      CourseEnrollments(
        success: json["success"],
        data:
            List<Datummmm>.from(json["data"].map((x) => Datummmm.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datummmm {
  int id;
  String instructorName;
  String courseSessionName;
  int courseSessionId;
  String startDate;
  String endDate;
  String semester;

  Datummmm({
    required this.id,
    required this.instructorName,
    required this.courseSessionName,
    required this.courseSessionId,
    required this.startDate,
    required this.endDate,
    required this.semester,
  });

  factory Datummmm.fromJson(Map<String, dynamic> json) => Datummmm(
        id: json["id"],
        instructorName: json["instructor_name"],
        courseSessionName: json["course_session_name"],
        courseSessionId: json["course_session_id"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        semester: json["semester"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "instructor_name": instructorName,
        "course_session_name": courseSessionName,
        "course_session_id": courseSessionId,
        "start_date": startDate,
        "end_date": endDate,
        "semester": semester,
      };
}
