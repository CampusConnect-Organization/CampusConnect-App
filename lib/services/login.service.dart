// ignore_for_file: body_might_complete_normally_nullable

import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:campus_connect_app/models/auth/authentication.models.dart';
import 'package:campus_connect_app/models/error.model.dart';
import 'package:campus_connect_app/utils/constants.dart';

class LoginAPIService {
  Future<dynamic> login(String username, String password) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.loginEndpoint);
      var response = await http.post(url, body: {
        "username": username,
        "password": password,
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
}
