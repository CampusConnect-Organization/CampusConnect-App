// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'dart:convert';

Notification notificationFromJson(String str) => Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
    bool success;
    List<NotificationData> data;
    String message;

    Notification({
        required this.success,
        required this.data,
        required this.message,
    });

    factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        success: json["success"],
        data: List<NotificationData>.from(json["data"].map((x) => NotificationData.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
    };
}

class NotificationData {
    String title;
    String body;

    NotificationData({
        required this.title,
        required this.body,
    });

    factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
        title: json["title"],
        body: json["body"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
    };
}
