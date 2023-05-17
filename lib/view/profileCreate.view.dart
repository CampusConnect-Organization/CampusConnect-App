// ignore_for_file: avoid_print

import 'dart:io';

import 'package:campus_connect_app/models/error.model.dart';
import 'package:campus_connect_app/models/profile.model.dart';
import 'package:campus_connect_app/services/profile.service.dart';
import 'package:campus_connect_app/utils/global.colors.dart';
import 'package:campus_connect_app/utils/snackbar.dart';
import 'package:campus_connect_app/view/home.view.dart';
import 'package:campus_connect_app/view/widgets/button.global.dart';
import 'package:campus_connect_app/view/widgets/text.form.global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../utils/constants.dart';

class ProfileCreateView extends StatefulWidget {
  const ProfileCreateView({super.key});

  @override
  State<ProfileCreateView> createState() => ProfileCreateViewState();
}

class ProfileCreateViewState extends State<ProfileCreateView> {
  late final Profile profile;
  late final Errors errors;

  DateTime selectedDate = DateTime.now();
  File? image;
  List<String> options = ['male', 'female', 'other'];
  String? selectedOption;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController academicsController = TextEditingController();

  Future pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;
      final imageTemp = File(pickedImage.path);
      setState(() {
        image = imageTemp;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        initialDate: selectedDate,
        context: context,
        firstDate: DateTime(1960, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Profile"),
        centerTitle: true,
        leading: const IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: null,
        ),
        backgroundColor: GlobalColors.mainColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    await pickImage();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 50,
                    backgroundImage: image != null ? FileImage(image!) : null,
                    child: image == null
                        ? const Icon(
                            Icons.add,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormGlobal(
                  labelText: "First Name",
                  controller: firstNameController,
                  text: "Enter first name",
                  textInputType: TextInputType.text,
                  obscure: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormGlobal(
                  controller: lastNameController,
                  text: "Enter last name",
                  textInputType: TextInputType.text,
                  obscure: false,
                  labelText: "Last Name",
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormGlobal(
                  controller: phoneController,
                  text: "Enter phone number",
                  textInputType: TextInputType.number,
                  obscure: false,
                  labelText: "Phone Number",
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    hintText: 'Select an option',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding: const EdgeInsets.only(top: 3, left: 14),
                  ),
                  value: selectedOption,
                  onChanged: (newValue) {
                    setState(() {
                      selectedOption = newValue;
                    });
                  },
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(titleCase(value)),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormGlobal(
                  controller: dateController,
                  text: "Enter DOB",
                  textInputType: TextInputType.none,
                  obscure: false,
                  labelText: "Date of Birth",
                  onTap: () {
                    _selectDate(context);
                    dateController.text =
                        DateFormat('yyyy-MM-dd').format(selectedDate);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormGlobal(
                  controller: addressController,
                  text: "Enter your address",
                  textInputType: TextInputType.streetAddress,
                  obscure: false,
                  labelText: "Address",
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormGlobal(
                  controller: academicsController,
                  text: "Enter your academics",
                  textInputType: TextInputType.text,
                  obscure: false,
                  labelText: "Academics",
                ),
                const SizedBox(
                  height: 20,
                ),
                ButtonGlobal(
                    text: "Submit",
                    onTap: () async {
                      try {
                        if (image == null) {
                          generateErrorSnackbar(
                              "Error", "Please select a profile picture");
                          return;
                        }
                        dynamic result =
                            await ProfileAPIService().createProfile(
                          phoneController.text,
                          selectedOption!,
                          dateController.text,
                          addressController.text,
                          firstNameController.text,
                          lastNameController.text,
                          academicsController.text,
                          image!,
                        );

                        if (result is Profile) {
                          profile = result;
                          if (profile.success) {
                            Get.off(() => const HomeView());
                            generateSuccessSnackbar("Success", profile.message);
                          }
                        } else if (result is Errors) {
                          errors = result;
                          generateErrorSnackbar("Error", errors.message);
                        }
                      } catch (e) {
                        generateErrorSnackbar(
                            "Error", "An unspecified error occurred!");
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
