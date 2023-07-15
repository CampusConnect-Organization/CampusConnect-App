// ignore_for_file: avoid_print

import 'package:campus_connect_app/models/auth/authentication.models.dart';
import 'package:campus_connect_app/models/error.model.dart';
import 'package:campus_connect_app/utils/global.colors.dart';
import 'package:campus_connect_app/view/home.view.dart';
import 'package:campus_connect_app/view/register.view.dart';
import 'package:campus_connect_app/widgets/button.global.dart';
import 'package:campus_connect_app/widgets/text.form.global.dart';
import 'package:flutter/material.dart';
import 'package:campus_connect_app/services/login.service.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:campus_connect_app/utils/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/register.service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final Authentication model;
  late final Errors errors;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Container(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Image(
                      image: AssetImage("images/logo-dark.png"),
                      height: 150,
                      width: 150,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "CampusConnect",
                      style: TextStyle(
                        color: GlobalColors.mainColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Login to your account",
                      style: TextStyle(
                        color: GlobalColors.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Email Address
                  TextFormGlobal(
                    controller: usernameController,
                    obscure: false,
                    labelText: "Username",
                    text: 'Username',
                    textInputType: TextInputType.text,
                  ),
                  //// Password Field
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormGlobal(
                    controller: passwordController,
                    obscure: true,
                    text: 'Password',
                    labelText: "Password",
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ButtonGlobal(
                    text: 'Login',
                    onTap: () async {
                      try {
                        dynamic result = (await LoginAPIService().login(
                          usernameController.text,
                          passwordController.text,
                        ))!;
                        if (result is Authentication) {
                          model = result;
                          if (model.success) {
                            SharedPreferences pref = await prefs;
                            await pref.setString(
                                "accessToken", model.data.accessToken);
                            await pref.setString(
                                "refreshToken", model.data.refreshToken);
                            Get.off(() => const HomeView());
                            generateSuccessSnackbar("Success", model.message);
                            await RegisterAPIService().registerFCMDevice();
                          }
                        } else if (result is Errors) {
                          errors = result;
                          generateErrorSnackbar("Error", errors.message);
                          passwordController.text = "";
                        } else {
                          // Show an error dialog
                          generateErrorSnackbar(
                              "Error", "An unspecified error occurred!");
                        }
                      } catch (e) {
                        generateErrorSnackbar(
                            "Error", "An unspecified error occurred");
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?"),
            InkWell(
              onTap: () {
                Get.off(() => const RegisterView());
              },
              child: Text(
                " Signup",
                style: TextStyle(color: GlobalColors.mainColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
