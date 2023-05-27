import 'dart:developer';
import 'package:campus_connect_app/models/course.enrollments.model.dart';
import 'package:campus_connect_app/models/student.courses.model.dart';
import 'package:campus_connect_app/models/courses.model.dart';
import 'package:campus_connect_app/models/course.session.model.dart';
import 'package:campus_connect_app/models/error.model.dart';
import 'package:campus_connect_app/utils/constants.dart';
import 'package:campus_connect_app/view/login.view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class CourseAPIService {
  Future<dynamic> getCourses() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.coursesEndpoint);
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http
          .get(url, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        Courses courses = coursesFromJson(response.body);
        return courses;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<dynamic> getStudentCourses() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.studentCoursesEndpoint);
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http
          .get(url, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        StudentCourses studentCourses = studentCoursesFromJson(response.body);
        return studentCourses;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<dynamic> getCourseSessions() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.courseSessionsEndpoint);
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http
          .get(url, headers: {"Authorization": "Bearer $accessToken"});

      if (response.statusCode == 200) {
        CourseSessions courseSession = courseSessionFromJson(response.body);
        return courseSession;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<dynamic> getCourseEnrollments() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.courseEnrollmentsEndpoint);
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http
          .get(url, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        CourseEnrollments enrollments =
            courseEnrollmentsFromJson(response.body);
        return enrollments;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (error) {
      log(error.toString());
    }
  }
}
