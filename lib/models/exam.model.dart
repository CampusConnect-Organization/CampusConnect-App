// To parse this JSON data, do
//
//     final exams = examsFromJson(jsonString);

import 'dart:convert';

Exams examsFromJson(String str) => Exams.fromJson(json.decode(str));

String examsToJson(Exams data) => json.encode(data.toJson());

class Exams {
  bool success;
  List<Datum> data;
  String message;

  Exams({
    required this.success,
    required this.data,
    required this.message,
  });

  factory Exams.fromJson(Map<String, dynamic> json) => Exams(
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
  String instructorName;
  String courseSessionName;
  String examType;
  int totalMarks;
  int passMarks;
  String date;
  String time;
  int courseSession;

  Datum({
    required this.id,
    required this.instructorName,
    required this.courseSessionName,
    required this.examType,
    required this.totalMarks,
    required this.passMarks,
    required this.date,
    required this.time,
    required this.courseSession,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        instructorName: json["instructor_name"],
        courseSessionName: json["course_session_name"],
        examType: json["exam_type"],
        totalMarks: json["total_marks"],
        passMarks: json["pass_marks"],
        date: json["date"],
        time: json["time"],
        courseSession: json["course_session"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "instructor_name": instructorName,
        "course_session_name": courseSessionName,
        "exam_type": examType,
        "total_marks": totalMarks,
        "pass_marks": passMarks,
        "date": date,
        "time": time,
        "course_session": courseSession,
      };
}
