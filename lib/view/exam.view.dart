import 'package:campus_connect_app/widgets/greyText.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campus_connect_app/models/error.model.dart';
import 'package:campus_connect_app/models/exams/exam.model.dart';
import 'package:campus_connect_app/services/exam.service.dart';
import 'package:campus_connect_app/utils/constants.dart';
import 'package:campus_connect_app/utils/global.colors.dart';
import 'package:campus_connect_app/view/home.view.dart';

class ExamView extends StatefulWidget {
  const ExamView({Key? key}) : super(key: key);

  @override
  _ExamViewState createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamView> {
  Exams? exams;
  Errors? errors;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    fetchExams();
  }

  Future<void> fetchExams() async {
    setState(() {
      isRefreshing = true;
    });

    dynamic data = await ExamAPIService().getExams();

    if (data is Exams) {
      setState(() {
        exams = data;
        isRefreshing = false;
      });
    } else if (data is Errors) {
      setState(() {
        errors = data;
        isRefreshing = false;
      });
    }
  }

  Future<void> refreshData() async {
    await fetchExams();
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
            ),
          ),
        ],
      ),
      body: exams != null
          ? RefreshIndicator(
              onRefresh: refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: exams!.data.length,
                  itemBuilder: (context, index) {
                    List<Datum>? examList = exams?.data;
                    var currentItem = examList?[index];

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
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GreyText(text: "Exam Date: ${currentItem.date}"),
                          const SizedBox(
                            height: 10,
                          ),
                          GreyText(
                              text:
                                  "Exam Type: ${titleCase(currentItem.examType)}"),
                          const SizedBox(
                            height: 10,
                          ),
                          GreyText(text: "Exam Time: ${currentItem.time}"),
                          const SizedBox(
                            height: 10,
                          ),
                          GreyText(
                              text: "Full Marks: ${currentItem.totalMarks}"),
                          const SizedBox(
                            height: 10,
                          ),
                          GreyText(
                              text: "Pass Marks: ${currentItem.passMarks}"),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          : Center(
              child: isRefreshing
                  ? CircularProgressIndicator(
                      color: GlobalColors.mainColor,
                    )
                  : const Text("Failed to fetch exams."),
            ),
    );
  }
}
