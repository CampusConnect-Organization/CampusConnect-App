import 'dart:convert';

Result resultFromJson(String str) => Result.fromJson(json.decode(str));

String resultToJson(Result data) => json.encode(data.toJson());

class Result {
  bool success;
  List<Data> data;
  String message;

  Result({
    required this.success,
    required this.data,
    required this.message,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        success: json["success"],
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Data {
  int id;
  String symbolNumber;
  String year;
  String season;
  Map<String, String> result;

  Data({
    required this.id,
    required this.symbolNumber,
    required this.year,
    required this.season,
    required this.result,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        symbolNumber: json["symbol_number"],
        year: json["year"],
        season: json["season"],
        result: Map<String, String>.from(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol_number": symbolNumber,
        "year": year,
        "season": season,
        "result": result,
      };
}
