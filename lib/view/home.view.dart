// ignore_for_file: avoid_print

import 'dart:async';

import 'package:campus_connect_app/services/profile.service.dart';
import 'package:campus_connect_app/utils/dialog.dart';
import 'package:campus_connect_app/utils/global.colors.dart';
import 'package:campus_connect_app/utils/snackbar.dart';
import 'package:campus_connect_app/view/login.view.dart';
import 'package:campus_connect_app/view/widgets/button.home.dart';
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
    Timer(const Duration(seconds: 1), _fetchProfile);
  }

  Future<void> _fetchProfile() async {
    final profile = await ProfileAPIService().getProfile();
    if (profile is Profile) {
      setState(() {
        _profile = profile;
      });
    } else {
      print("Profile doesn't exist!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences pref = await prefs;
              pref.remove("accessToken");
              showConfirmationDialog("Are you sure you want to logout?", () {
                Get.to(() => const LoginView());
                generateSuccessSnackbar("Success", "Logged out successfully!");
              });
            },
          ),
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: GlobalColors.mainColor,
      ),
      body: Center(
        child: _profile != null
            ? Container(
                padding: const EdgeInsets.only(top: 190.0),
                child: Column(
                  children: <Widget>[
                    Text("Welcome ${_profile!.data.fullName}"),
                    const SizedBox(
                      height: 20,
                    ),
                    HomeButtons(
                      text: "Profile",
                      icon: Icons.person,
                      onPressed: () {},
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    HomeButtons(
                      text: "Courses",
                      icon: Icons.book_rounded,
                      onPressed: () {},
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    HomeButtons(
                      text: "Grades",
                      icon: Icons.percent,
                      onPressed: () {},
                    )
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
