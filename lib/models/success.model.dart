// To parse this JSON data, do
//
//     final success = successFromJson(jsonString);

import 'dart:convert';

Success successFromJson(String str) => Success.fromJson(json.decode(str));

String successToJson(Success data) => json.encode(data.toJson());

class Success {
  bool success;
  dynamic data;
  String message;

  Success({
    required this.success,
    this.data,
    required this.message,
  });

  factory Success.fromJson(Map<String, dynamic> json) => Success(
        success: json["success"],
        data: json["data"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data,
        "message": message,
      };
}
