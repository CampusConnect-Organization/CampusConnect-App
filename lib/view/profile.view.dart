// ignore_for_file: unused_field

import 'dart:async';

import 'package:campus_connect_app/models/profile.model.dart';
import 'package:campus_connect_app/services/profile.service.dart';
import 'package:campus_connect_app/utils/constants.dart';
import 'package:campus_connect_app/utils/global.colors.dart';
import 'package:campus_connect_app/view/home.view.dart';
import 'package:campus_connect_app/view/login.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  Profile? _profile;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final profile = await ProfileAPIService().getProfile();
    if (profile is Profile) {
      setState(() {
        _profile = profile;
      });
    } else {
      Get.to(() => const LoginView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.to(const HomeView());
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: const [
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ))
        ],
        backgroundColor: GlobalColors.mainColor,
        foregroundColor: Colors.white,
      ),
      body: _profile != null
          ? SingleChildScrollView(
              padding: const EdgeInsets.only(top: 50),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(ApiConstants.baseUrl +
                              _profile!.data.profilePicture),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: Icon(
                                _profile!.data.isVerified
                                    ? Icons.check_circle
                                    : Icons.close,
                                color: _profile!.data.isVerified
                                    ? Colors.green
                                    : Colors.red,
                                size: 30,
                              ),
                            ))
                      ]),
                      const SizedBox(height: 20),
                      Text(
                        _profile!.data.fullName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.phone,
                            color: Colors.grey,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            _profile!.data.phone,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        elevation: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person, color: Colors.grey),
                                  const SizedBox(width: 10),
                                  Text(
                                    titleCase(_profile!.data.gender),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  const Icon(Icons.date_range,
                                      color: Colors.grey),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${_profile!.data.dateOfBirth.year.toString()}-${_profile!.data.dateOfBirth.month.toString()}-${_profile!.data.dateOfBirth.day.toString()}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.grey),
                                  const SizedBox(width: 10),
                                  Text(
                                    _profile!.data.address,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  const Icon(Icons.numbers, color: Colors.grey),
                                  const SizedBox(width: 10),
                                  Text(
                                    _profile!.data.symbolNumber ?? "None",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  const Icon(Icons.book, color: Colors.grey),
                                  const SizedBox(width: 10),
                                  Text(
                                    _profile!.data.academics,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
              color: GlobalColors.mainColor,
            )),
    );
  }
}
