import 'dart:convert';

Book bookFromJson(String str) => Book.fromJson(json.decode(str));

String bookToJson(Book data) => json.encode(data.toJson());

class Book {
  bool success;
  List<BookData> data;
  String message;

  Book({
    required this.success,
    required this.data,
    required this.message,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        success: json["success"],
        data:
            List<BookData>.from(json["data"].map((x) => BookData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class BookData {
  int id;
  String title;
  String author;
  String category;

  BookData({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
  });

  factory BookData.fromJson(Map<String, dynamic> json) => BookData(
        id: json["id"],
        title: json["title"],
        author: json["author"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "author": author,
        "category": category,
      };
}
