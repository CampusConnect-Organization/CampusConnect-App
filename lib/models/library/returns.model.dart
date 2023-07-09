// To parse this JSON data, do
//
//     final returns = returnsFromJson(jsonString);

import 'dart:convert';

Returns returnsFromJson(String str) => Returns.fromJson(json.decode(str));

String returnsToJson(Returns data) => json.encode(data.toJson());

class Returns {
  bool success;
  List<ReturnData> data;
  String message;

  Returns({
    required this.success,
    required this.data,
    required this.message,
  });

  factory Returns.fromJson(Map<String, dynamic> json) => Returns(
        success: json["success"],
        data: List<ReturnData>.from(
            json["data"].map((x) => ReturnData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class ReturnData {
  int id;
  String bookName;
  String borrowedDate;
  String borrower;
  String returnDate;

  ReturnData({
    required this.id,
    required this.bookName,
    required this.borrowedDate,
    required this.borrower,
    required this.returnDate,
  });

  factory ReturnData.fromJson(Map<String, dynamic> json) => ReturnData(
        id: json["id"],
        bookName: json["book_name"],
        borrowedDate: json["borrowed_date"],
        borrower: json["borrower"],
        returnDate: json["return_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "book_name": bookName,
        "borrowed_date": borrowedDate,
        "borrower": borrower,
        "return_date": returnDate,
      };
}
