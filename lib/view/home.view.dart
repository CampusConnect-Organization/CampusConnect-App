// ignore_for_file: avoid_print

import 'dart:async';

import 'package:campus_connect_app/services/profile.service.dart';
import 'package:campus_connect_app/utils/constants.dart';
import 'package:campus_connect_app/utils/dialog.dart';
import 'package:campus_connect_app/utils/global.colors.dart';
import 'package:campus_connect_app/utils/snackbar.dart';
import 'package:campus_connect_app/view/calendar.view.dart';
import 'package:campus_connect_app/view/course.view.dart';
import 'package:campus_connect_app/view/exam.view.dart';
import 'package:campus_connect_app/view/library.view.dart';
import 'package:campus_connect_app/view/login.view.dart';
import 'package:campus_connect_app/view/result.view.dart';
import 'package:campus_connect_app/widgets/profile.widget.dart';
import 'package:flutter/services.dart';
import 'package:campus_connect_app/view/profile.view.dart';
import 'package:campus_connect_app/view/profileCreate.view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campus_connect_app/models/profile.model.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  Profile? _profile;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), fetchProfile);
  }

  Future<void> fetchProfile() async {
    final profile = await ProfileAPIService().getProfile();
    if (profile is Profile) {
      setState(() {
        _profile = profile;
      });
    } else {
      Get.off(() => const ProfileCreateView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences pref = await prefs;

              showConfirmationDialog("Are you sure you want to logout?", () {
                pref.remove("accessToken");
                Get.offAll(() => const LoginView());
                generateSuccessSnackbar("Success", "Logged out successfully!");
              });
            },
          ),
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: GlobalColors.mainColor,
      ),
      body: WillPopScope(
        onWillPop: () => _onBackButtonPressed(context),
        child: _profile != null
            ? Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
                height: MediaQuery.of(context).size.height,
                color: Colors.grey.shade300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 140,
                      color: Colors.transparent,
                      child: ProfileWidget(
                          firstName: _profile!.data.firstName,
                          profilePicture: _profile!.data.profilePicture!),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          getExpanded("profile", "Profile", "View Profile", () {
                            Get.to(() => const UserProfileView());
                          }),
                          getExpanded("courses", "Courses", "View Courses", () {
                            Get.to(() => const CourseView());
                          }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          getExpanded(
                              "grade", "Results", "View Final Exam Results",
                              () {
                            Get.to(() => const ResultView());
                          }),
                          getExpanded("exam", "Exams", "View Exams", () {
                            Get.to(() => const ExamView());
                          }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          getExpanded("library", "Library", "Access Library",
                              () {
                            Get.to(() => const LibraryView());
                          }),
                          getExpanded("calendar", "Calendar", "View Calendar",
                              () {
                            Get.to(() => const CalendarView());
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: GlobalColors.mainColor,
                ),
              ),
      ),
    );
  }

  _onBackButtonPressed(BuildContext context) async {
    bool exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirmation"),
            content: const Text("Do you want to close the app?"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: const Text(
                  "Yes",
                ),
              ),
            ],
          );
        });

    return exitApp;
  }
}
