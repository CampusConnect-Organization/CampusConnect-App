// ignore_for_file: body_might_complete_normally_nullable

import 'dart:developer';
import 'package:campus_connect_app/models/success.model.dart';
import 'package:campus_connect_app/view/login.view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:campus_connect_app/models/auth/authentication.models.dart';
import 'package:campus_connect_app/models/error.model.dart';
import 'package:campus_connect_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class RegisterAPIService {
  Future<dynamic> register(
      String username, String password, String email) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.registerEndpoint);
      var response = await http.post(url, body: {
        "username": username,
        "password": password,
        "email": email,
      });
      if (response.statusCode == 200) {
        Authentication model = authenticationFromJson(response.body);
        return model;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<dynamic> registerFCMDevice() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Object? accessToken = prefs.get("accessToken");
      await messaging.requestPermission();
      String? token = await messaging.getToken();
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.registerFCMEndpoint}");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }

      var body = {"device_id": token};
      var response = await http.post(url,
          body: body, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        Success success = successFromJson(response.body);
        return success;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (error) {
      rethrow;
    }
  }
}
