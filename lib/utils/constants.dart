import 'package:flutter/material.dart';

class ApiConstants {
  static String baseUrl = 'http://192.168.1.66:8000/';
  static String loginEndpoint = 'api/auth/login/';
  static String registerEndpoint = 'api/auth/register/';
  static String profileEndpoint = "api/student-profile/";
  static String coursesEndpoint = "api/courses/courses/";
  static String courseSessionsEndpoint = "api/courses/sessions/";
  static String studentCoursesEndpoint = "api/courses/student-courses/";
  static String courseEnrollmentsEndpoint = "api/courses/enrollments/";
  static String examsEndpoint = "api/grades/exams/";
  static String resultsEndpoint = "api/results/";
}

String titleCase(String input) {
  if (input.isEmpty) {
    return input;
  }

  List<String> words = input.toLowerCase().split(' ');

  for (int i = 0; i < words.length; i++) {
    words[i] = words[i][0].toUpperCase() + words[i].substring(1);
  }

  return words.join(' ');
}

Expanded getExpanded(
    String image, String mainText, String subText, Function()? onTap) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          left: 10.0,
          top: 10.0,
          right: 10.0,
          bottom: 10.0,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(5.0),
          ),
          boxShadow: [BoxShadow()],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "images/$image.png",
              height: 80.0,
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              mainText,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              subText,
              style: const TextStyle(
                fontSize: 13.0,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
