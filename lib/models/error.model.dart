// To parse this JSON data, do
//
//     final errors = errorsFromJson(jsonString);

import 'dart:convert';

Errors errorsFromJson(String str) => Errors.fromJson(json.decode(str));

String errorsToJson(Errors data) => json.encode(data.toJson());

class Errors {
  bool success;
  dynamic errors;
  String message;

  Errors({
    required this.success,
    this.errors,
    required this.message,
  });

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        success: json["success"],
        errors: json["errors"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "errors": errors,
        "message": message,
      };
}
