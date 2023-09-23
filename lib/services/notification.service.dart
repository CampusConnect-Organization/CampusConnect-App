import 'dart:developer';
import 'package:campus_connect_app/models/error.model.dart';
import 'package:campus_connect_app/models/notification.model.dart' as noti;
import 'package:campus_connect_app/view/login.view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class NotificationAPIService {
  Future<dynamic> getNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.notificationEndpoint);
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http
          .get(url, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        noti.Notification notifications = noti.notificationFromJson(response.body);
        return notifications;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (error) {
      log(error.toString());
    }
  }
}
