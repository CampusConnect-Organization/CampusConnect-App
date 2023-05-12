// ignore_for_file: body_might_complete_normally_nullable

import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:campus_connect_app/models/authentication.models.dart';
import 'package:campus_connect_app/models/error.model.dart';
import 'package:campus_connect_app/utils/constants.dart';

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
}
