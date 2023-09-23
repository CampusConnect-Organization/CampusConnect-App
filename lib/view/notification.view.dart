import 'package:flutter/material.dart';
import 'package:campus_connect_app/models/notification.model.dart' as noti;
import 'package:campus_connect_app/services/notification.service.dart';
import 'package:campus_connect_app/utils/global.colors.dart';
import 'package:campus_connect_app/utils/snackbar.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List<noti.NotificationData> notifications = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
    });
    dynamic result = await NotificationAPIService().getNotifications();
    if (result is noti.Notification) {
      setState(() {
        notifications = result.data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      generateErrorSnackbar("Error", "Notifications couldn't be fetched!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: GlobalColors.mainColor,
        centerTitle: true,
      ),
      body: buildNotificationList(),
    );
  }

  Widget buildNotificationList() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: GlobalColors.mainColor,
        ),
      );
    } else if (notifications.isEmpty) {
      return Center(
        child: Text(
          'No notifications available.',
          style: TextStyle(fontSize: 18),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return buildNotificationItem(notifications[index]);
        },
      );
    }
  }

  Widget buildNotificationItem(noti.NotificationData notification) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          notification.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            notification.body,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
