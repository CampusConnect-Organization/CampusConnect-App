// To parse this JSON data, do
//
//     final bookInstance = bookInstanceFromJson(jsonString);

import 'dart:convert';

BookInstance bookInstanceFromJson(String str) =>
    BookInstance.fromJson(json.decode(str));

String bookInstanceToJson(BookInstance data) => json.encode(data.toJson());

class BookInstance {
  bool success;
  List<BookInstanceData> data;
  String message;

  BookInstance({
    required this.success,
    required this.data,
    required this.message,
  });

  factory BookInstance.fromJson(Map<String, dynamic> json) => BookInstance(
        success: json["success"],
        data: List<BookInstanceData>.from(
            json["data"].map((x) => BookInstanceData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class BookInstanceData {
  int id;
  String bookName;
  String bookNumber;
  bool borrowed;

  BookInstanceData({
    required this.id,
    required this.bookName,
    required this.bookNumber,
    required this.borrowed,
  });

  factory BookInstanceData.fromJson(Map<String, dynamic> json) =>
      BookInstanceData(
        id: json["id"],
        bookName: json["book_name"],
        bookNumber: json["book_number"],
        borrowed: json["borrowed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "book_name": bookName,
        "book_number": bookNumber,
        "borrowed": borrowed,
      };
}
