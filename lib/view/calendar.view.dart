import 'package:campus_connect_app/utils/global.colors.dart';
import 'package:campus_connect_app/view/home.view.dart';
import 'package:flutter/material.dart';
import 'package:clean_nepali_calendar/clean_nepali_calendar.dart';
import 'package:get/get.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late final NepaliCalendarController _calendarController =
      NepaliCalendarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
        centerTitle: true,
        backgroundColor: GlobalColors.mainColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.to(() => const HomeView());
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: CleanNepaliCalendar(
          controller: _calendarController,
        ),
      ),
    );
  }
}
