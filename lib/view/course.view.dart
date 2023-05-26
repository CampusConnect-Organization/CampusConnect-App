import 'package:campus_connect_app/models/course.enrollment.model.dart';
import 'package:campus_connect_app/models/course.session.model.dart';
import 'package:campus_connect_app/models/courses.model.dart';
import 'package:campus_connect_app/models/error.model.dart';
import 'package:campus_connect_app/services/course.service.dart';
import 'package:campus_connect_app/utils/global.colors.dart';
import 'package:campus_connect_app/view/home.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseView extends StatefulWidget {
  const CourseView({Key? key}) : super(key: key);

  @override
  State<CourseView> createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView>
    with SingleTickerProviderStateMixin {
  late final Errors errors;
  Courses? courses;
  CourseSessions? courseSessions;
  CourseEnrollments? enrollments;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fetchCourses();
    fetchCourseSessions();
    fetchCourseEnrollments();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<dynamic> fetchCourses() async {
    dynamic data = await CourseAPIService().getCourses();
    if (data is Courses) {
      setState(() {
        courses = data;
      });
    } else if (data is Errors) {
      errors = data;
    }
  }

  Future<dynamic> fetchCourseSessions() async {
    dynamic data = await CourseAPIService().getCourseSessions();
    if (data is CourseSessions) {
      setState(() {
        courseSessions = data;
      });
    } else if (data is Errors) {
      errors = data;
    }
  }

  Future<dynamic> fetchCourseEnrollments() async {
    dynamic data = await CourseAPIService().getEnrollments();
    if (data is CourseEnrollments) {
      setState(() {
        enrollments = data;
      });
    } else if (data is Errors) {
      errors = data;
    }
  }

  Map<String, List<Datum>> groupCoursesBySemester() {
    Map<String, List<Datum>> groupedCourses = {};

    if (courses != null) {
      for (Datum course in courses!.data) {
        if (groupedCourses.containsKey(course.semester)) {
          groupedCourses[course.semester]!.add(course);
        } else {
          groupedCourses[course.semester] = [course];
        }
      }
    }
    List<String> sortedKeys = groupedCourses.keys.toList()
      ..sort((a, b) => int.parse(a.replaceAll(RegExp('[^0-9]'), ''))
          .compareTo(int.parse(b.replaceAll(RegExp('[^0-9]'), ''))));

    Map<String, List<Datum>> sortedGroupedCourses = {};
    for (String key in sortedKeys) {
      sortedGroupedCourses[key] = groupedCourses[key]!;
    }

    return sortedGroupedCourses;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Datum>> groupedCourses = groupCoursesBySemester();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Course Details"),
        backgroundColor: GlobalColors.mainColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.to(() => const HomeView());
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: TabBar(
            indicatorColor: Colors.white,
            controller: _tabController,
            tabs: const [
              Tab(text: 'Courses'),
              Tab(text: 'Classes'),
              Tab(text: 'My Enrolls'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          courses != null
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: groupedCourses.length,
                        itemBuilder: (context, index) {
                          String semester = groupedCourses.keys.toList()[index];
                          List<Datum> semesterCourses =
                              groupedCourses[semester]!;

                          return ExpansionTile(
                            title: Text(
                              "$semester Semester",
                            ),
                            children: semesterCourses
                                .map((course) => ListTile(
                                      title: Text(course.title),
                                      subtitle: Text(
                                          "Course Code: ${course.courseCode}"),
                                    ))
                                .toList(),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Center(
                  child:
                      CircularProgressIndicator(color: GlobalColors.mainColor),
                ),
          // Placeholder for "Classes" tab content
          courseSessions != null
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: courseSessions?.data.length,
                        itemBuilder: (context, index) {
                          List<Datumm>? sessions = courseSessions?.data;
                          var currentItem = sessions?[index];

                          return Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ))),
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Text(
                                  currentItem!.course,
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Duration: ${currentItem.start}-${currentItem.end}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Instructor: ${currentItem.instructor}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text("No classes are currently running!"),
                ),
          // Placeholder for "Enrolls" tab content
          enrollments != null
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: enrollments?.data.length,
                        itemBuilder: (context, index) {
                          List<Datummm>? enrolls = enrollments?.data;
                          var currentItem = enrolls?[index];

                          return Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ))),
                            margin: const EdgeInsets.all(15.0),
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Text(
                                  currentItem!.course,
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Course Code: ${currentItem.courseCode}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Semester: ${currentItem.semester}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text("You haven't enrolled in any courses!")),
        ],
      ),
    );
  }
}
