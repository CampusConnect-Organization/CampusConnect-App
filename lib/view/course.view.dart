import 'package:campus_connect_app/widgets/greyText.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campus_connect_app/models/error.model.dart';
import 'package:campus_connect_app/models/courses/course.enrollments.model.dart';
import 'package:campus_connect_app/models/courses/student.courses.model.dart';
import 'package:campus_connect_app/models/courses/course.session.model.dart';
import 'package:campus_connect_app/models/courses/courses.model.dart';
import 'package:campus_connect_app/services/course.service.dart';
import 'package:campus_connect_app/utils/global.colors.dart';
import 'package:campus_connect_app/view/home.view.dart';

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
  StudentCourses? studentCourses;
  CourseEnrollments? enrollments;
  late TabController _tabController;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    fetchCourses();
    fetchCourseSessions();
    fetchStudentCourses();
    fetchEnrollments();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<dynamic> fetchCourses() async {
    setState(() {
      isRefreshing = true;
    });

    dynamic data = await CourseAPIService().getCourses();
    if (data is Courses) {
      setState(() {
        courses = data;
        isRefreshing = false;
      });
    } else if (data is Errors) {
      errors = data;
      isRefreshing = false;
    }
  }

  Future<dynamic> fetchEnrollments() async {
    setState(() {
      isRefreshing = true;
    });

    dynamic data = await CourseAPIService().getCourseEnrollments();
    if (data is CourseEnrollments) {
      setState(() {
        enrollments = data;
        isRefreshing = false;
      });
    } else if (data is Errors) {
      errors = data;
      isRefreshing = false;
    }
  }

  Future<dynamic> fetchCourseSessions() async {
    setState(() {
      isRefreshing = true;
    });

    dynamic data = await CourseAPIService().getCourseSessions();
    if (data is CourseSessions) {
      setState(() {
        courseSessions = data;
        isRefreshing = false;
      });
    } else if (data is Errors) {
      errors = data;
      isRefreshing = false;
    }
  }

  Future<dynamic> fetchStudentCourses() async {
    setState(() {
      isRefreshing = true;
    });

    dynamic data = await CourseAPIService().getStudentCourses();
    if (data is StudentCourses) {
      setState(() {
        studentCourses = data;
        isRefreshing = false;
      });
    } else if (data is Errors) {
      errors = data;
      isRefreshing = false;
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

  Future<void> refreshData() async {
    await Future.wait([
      fetchCourses(),
      fetchCourseSessions(),
      fetchStudentCourses(),
      fetchEnrollments(),
    ]);
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
              Tab(text: 'My Courses'),
              Tab(text: "My Enrolls")
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RefreshIndicator(
            onRefresh: refreshData,
            child: courses != null
                ? ListView.builder(
                    itemCount: groupedCourses.length,
                    itemBuilder: (context, index) {
                      String semester = groupedCourses.keys.toList()[index];
                      List<Datum> semesterCourses = groupedCourses[semester]!;

                      return ExpansionTile(
                        title: Text(
                          "$semester Semester",
                        ),
                        children: semesterCourses
                            .map((course) => ListTile(
                                  title: Text(course.title),
                                  subtitle:
                                      Text("Course Code: ${course.courseCode}"),
                                ))
                            .toList(),
                      );
                    },
                  )
                : isRefreshing
                    ? Center(
                        child: CircularProgressIndicator(
                          color: GlobalColors.mainColor,
                        ),
                      )
                    : Center(
                        child: Text("Failed to fetch courses."),
                      ),
          ),
          // Placeholder for "Classes" tab content
          RefreshIndicator(
            onRefresh: fetchCourseSessions,
            child: courseSessions != null
                ? ListView.builder(
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
                            ),
                          ),
                        ),
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              currentItem!.course,
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            const SizedBox(height: 10),
                            GreyText(
                                text:
                                    "Duration: ${currentItem.start} - ${currentItem.end}"),
                            const SizedBox(height: 10),
                            GreyText(
                                text: "Instructor: ${currentItem.instructor}"),
                          ],
                        ),
                      );
                    },
                  )
                : isRefreshing
                    ? Center(
                        child: CircularProgressIndicator(
                          color: GlobalColors.mainColor,
                        ),
                      )
                    : const Center(
                        child: Text("No classes are currently running!"),
                      ),
          ),
          // Placeholder for "My Courses" tab content
          RefreshIndicator(
            onRefresh: fetchStudentCourses,
            child: studentCourses != null
                ? ListView.builder(
                    itemCount: studentCourses?.data.length,
                    itemBuilder: (context, index) {
                      List<Datummm>? enrolls = studentCourses?.data;
                      var currentItem = enrolls?[index];

                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              currentItem!.course,
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            const SizedBox(height: 10),
                            GreyText(
                                text: "Course Code: ${currentItem.courseCode}"),
                            const SizedBox(height: 10),
                            GreyText(text: "Semester: ${currentItem.semester}"),
                          ],
                        ),
                      );
                    },
                  )
                : isRefreshing
                    ? Center(
                        child: CircularProgressIndicator(
                          color: GlobalColors.mainColor,
                        ),
                      )
                    : Center(child: Text("You don't have any courses!")),
          ),
          // Placeholder for "My Enrolls" tab content
          RefreshIndicator(
            onRefresh: fetchEnrollments,
            child: enrollments != null
                ? ListView.builder(
                    itemCount: enrollments?.data.length,
                    itemBuilder: (context, index) {
                      List<Datummmm>? enrolls = enrollments?.data;
                      var currentItem = enrolls?[index];

                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                        ),
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              currentItem!.courseSessionName,
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            const SizedBox(height: 10),
                            GreyText(
                                text:
                                    "Duration: ${currentItem.startDate} - ${currentItem.endDate}"),
                            const SizedBox(height: 10),
                            GreyText(
                                text:
                                    "Instructor: ${currentItem.instructorName}"),
                            const SizedBox(height: 10),
                            GreyText(text: "Semester: ${currentItem.semester}"),
                          ],
                        ),
                      );
                    },
                  )
                : isRefreshing
                    ? Center(
                        child: CircularProgressIndicator(
                          color: GlobalColors.mainColor,
                        ),
                      )
                    : const Center(
                        child: Text("You haven't enrolled in any courses!"),
                      ),
          ),
        ],
      ),
    );
  }
}
