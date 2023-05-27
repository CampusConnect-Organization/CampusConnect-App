// ignore_for_file: must_be_immutable

import 'package:campus_connect_app/utils/constants.dart';
import 'package:campus_connect_app/utils/global.colors.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  ProfileWidget({
    Key? key,
    required this.profilePicture,
    required this.firstName,
  }) : super(key: key);

  final String profilePicture;
  final String firstName;
  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
                color: GlobalColors.mainColor,
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(50))),
            child: Column(
              children: [
                const SizedBox(
                  height: 40.0,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                  title: Text(
                    "Hi, ${widget.firstName}!",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white),
                  ),
                  subtitle: Text(
                    "Welcome to Campus Connect",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white54),
                  ),
                  trailing: CircleAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage(
                        ApiConstants.baseUrl + widget.profilePicture),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                )
              ],
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
