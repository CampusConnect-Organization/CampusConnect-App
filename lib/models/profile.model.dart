// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  bool success;
  Data data;
  String message;

  Profile({
    required this.success,
    required this.data,
    required this.message,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
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
  int id;
  String fullName;
  String firstName;
  String lastName;
  String phone;
  String gender;
  DateTime dateOfBirth;
  String address;
  String academics;
  bool isVerified;
  dynamic symbolNumber;

  Data({
    required this.id,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.gender,
    required this.dateOfBirth,
    required this.address,
    required this.academics,
    required this.isVerified,
    this.symbolNumber,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      phone: json["phone"],
      gender: json["gender"],
      dateOfBirth: DateTime.parse(json["date_of_birth"]),
      address: json["address"],
      academics: json["academics"],
      isVerified: json["is_verified"],
      symbolNumber: json["symbol_number"],
      fullName: json["full_name"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "gender": gender,
        "date_of_birth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "address": address,
        "academics": academics,
        "is_verified": isVerified,
        "symbol_number": symbolNumber,
        "full_name": fullName
      };
}
