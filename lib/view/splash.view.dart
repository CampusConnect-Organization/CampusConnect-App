import 'dart:async';

import 'package:campus_connect_app/utils/global.colors.dart';
import 'package:campus_connect_app/view/login.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Get.to(() => const LoginView());
    });
    return Center(
      child: Scaffold(
        backgroundColor: GlobalColors.mainColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(
                image: AssetImage("images/logo.png"),
                height: 150,
                width: 150,
              ),
              Text(
                "CampusConnect",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
