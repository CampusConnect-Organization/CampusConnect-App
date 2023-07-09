// To parse this JSON data, do
//
//     final authentication = authenticationFromJson(jsonString);

import 'dart:convert';

Authentication authenticationFromJson(String str) =>
    Authentication.fromJson(json.decode(str));

String authenticationToJson(Authentication data) => json.encode(data.toJson());

class Authentication {
  bool success;
  Data data;
  String message;

  Authentication({
    required this.success,
    required this.data,
    required this.message,
  });

  factory Authentication.fromJson(Map<String, dynamic> json) => Authentication(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  String accessToken;
  String refreshToken;

  Data({
    required this.accessToken,
    required this.refreshToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };
}
