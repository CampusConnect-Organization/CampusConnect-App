import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:campus_connect_app/view/login.view.dart';
import 'package:http/http.dart' as http;
import 'package:campus_connect_app/models/profile.model.dart';
import 'package:campus_connect_app/models/error.model.dart';
import 'package:campus_connect_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ProfileAPIService {
  Future<dynamic> getProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.profileEndpoint);
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http
          .get(url, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        Profile profile = profileFromJson(response.body);
        return profile;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<dynamic> createProfile(
      String phone,
      String gender,
      String dateOfBirth,
      String address,
      String firstName,
      String lastName,
      String academics,
      String semester,
      String symbolNumber,
      File? imageFile) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.profileEndpoint);
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var request = http.MultipartRequest("POST", url);
      request.headers["Authorization"] = "Bearer $accessToken";
      request.files.add(
        await http.MultipartFile.fromPath("profile_picture", imageFile!.path),
      );
      var body = {
        "phone": phone,
        "gender": gender,
        "date_of_birth": dateOfBirth,
        "address": address,
        "academics": academics,
        "first_name": firstName,
        "last_name": lastName,
        "semester": semester,
        "symbol_number": symbolNumber,
      };

      request.fields["data"] = json.encode(body);
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        Profile profile = profileFromJson(responseBody);
        return profile;
      } else {
        Errors errors = errorsFromJson(responseBody);
        return errors;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
