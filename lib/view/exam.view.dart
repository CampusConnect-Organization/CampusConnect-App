import 'package:campus_connect_app/models/error.model.dart';
import 'package:campus_connect_app/models/exam.model.dart';
import 'package:campus_connect_app/services/exam.service.dart';
import 'package:campus_connect_app/utils/constants.dart';
import 'package:campus_connect_app/utils/global.colors.dart';
import 'package:campus_connect_app/view/home.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamView extends StatefulWidget {
  const ExamView({super.key});

  @override
  State<ExamView> createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamView> {
  Exams? exams;
  Errors? errors;

  @override
  void initState() {
    super.initState();
    fetchExams();
  }

  Future<void> fetchExams() async {
    dynamic data = await ExamAPIService().getExams();
    if (data is Exams) {
      setState(() {
        exams = data;
      });
    } else if (data is Errors) {
      errors = data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Upcoming Exams"),
          centerTitle: true,
          backgroundColor: GlobalColors.mainColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.off(() => const HomeView());
            },
          ),
          actions: const [
            IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ))
          ],
        ),
        body: exams != null
            ? SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: exams!.data.length,
                  itemBuilder: ((context, index) {
                    List<Datum>? examList = exams?.data;
                    var currentItem = examList?[index];

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
                            currentItem!.courseSessionName,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Exam Date: ${currentItem.date}",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Exam Type: ${titleCase(currentItem.examType)}",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Exam Time: ${currentItem.time}",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Full Marks: ${currentItem.totalMarks}",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Pass Marks: ${currentItem.passMarks}",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                color: GlobalColors.mainColor,
              )));
  }
}
