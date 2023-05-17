// ignore_for_file: avoid_print

import 'dart:async';

import 'package:campus_connect_app/services/profile.service.dart';
import 'package:campus_connect_app/utils/constants.dart';
import 'package:campus_connect_app/utils/dialog.dart';
import 'package:campus_connect_app/utils/global.colors.dart';
import 'package:campus_connect_app/utils/snackbar.dart';
import 'package:campus_connect_app/view/login.view.dart';
import 'package:campus_connect_app/view/profile.view.dart';
import 'package:campus_connect_app/view/profileCreate.view.dart';
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
      Get.off(() => const ProfileCreateView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: GlobalColors.mainColor,
      ),
      drawer: Visibility(
        visible: _profile != null,
        child: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: GlobalColors.mainColor),
                accountName: _profile != null
                    ? Text(_profile!.data.fullName)
                    : const Text(""),
                accountEmail: _profile != null
                    ? Text(_profile!.data.phone)
                    : const Text(""),
                currentAccountPicture: CircleAvatar(
                  foregroundImage: NetworkImage(_profile != null
                      ? ApiConstants.baseUrl + _profile!.data.profilePicture!
                      : ""),
                ),
              ),
              const ListTile(
                leading: Icon(Icons.home),
                title: Text("Home"),
              ),
              const ListTile(
                leading: Icon(Icons.book_rounded),
                title: Text("Courses"),
              ),
              const ListTile(
                leading: Icon(Icons.person),
                title: Text("Profile"),
              ),
              const ListTile(
                leading: Icon(Icons.percent),
                title: Text("Grades"),
              ),
              const ListTile(
                leading: Icon(Icons.library_books),
                title: Text("Library"),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () async {
                  SharedPreferences pref = await prefs;
                  pref.remove("accessToken");
                  showConfirmationDialog("Are you sure you want to logout?",
                      () {
                    Get.off(() => const LoginView());
                    generateSuccessSnackbar(
                        "Success", "Logged out successfully!");
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: _profile != null
            ? Container(
                padding: const EdgeInsets.only(top: 150.0),
                child: Column(
                  children: <Widget>[
                    HomeButtons(
                      text: "Profile",
                      icon: Icons.person,
                      onPressed: () {
                        Get.to(() => const UserProfileView());
                      },
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
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    HomeButtons(
                      text: "Library",
                      icon: Icons.library_books,
                      onPressed: () {},
                    )
                  ],
                ),
              )
            : CircularProgressIndicator(
                color: GlobalColors.mainColor,
              ),
      ),
    );
  }
}
