// To parse this JSON data, do
//
//     final borrows = borrowsFromJson(jsonString);

import 'dart:convert';

Borrows borrowsFromJson(String str) => Borrows.fromJson(json.decode(str));

String borrowsToJson(Borrows data) => json.encode(data.toJson());

class Borrows {
  bool success;
  List<BorrowData> data;
  String message;

  Borrows({
    required this.success,
    required this.data,
    required this.message,
  });

  factory Borrows.fromJson(Map<String, dynamic> json) => Borrows(
        success: json["success"],
        data: List<BorrowData>.from(
            json["data"].map((x) => BorrowData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class BorrowData {
  int id;
  String bookCode;
  String bookName;
  String borrower;
  String borrowDate;
  bool returned;

  BorrowData({
    required this.id,
    required this.bookCode,
    required this.bookName,
    required this.borrower,
    required this.borrowDate,
    required this.returned,
  });

  factory BorrowData.fromJson(Map<String, dynamic> json) => BorrowData(
        id: json["id"],
        bookCode: json["book_code"],
        bookName: json["book_name"],
        borrower: json["borrower"],
        borrowDate: json["borrow_date"],
        returned: json["returned"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "book_code": bookCode,
        "book_name": bookName,
        "borrower": borrower,
        "borrow_date": borrowDate,
        "returned": returned,
      };
}
