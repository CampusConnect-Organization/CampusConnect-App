import 'package:flutter/material.dart';

import '../../models/error.model.dart';
import '../../models/library/returns.model.dart';
import '../../services/library.service.dart';
import '../../utils/global.colors.dart';

class ReturnsView extends StatefulWidget {
  const ReturnsView({Key? key}) : super(key: key);

  @override
  State<ReturnsView> createState() => _ReturnsViewState();
}

class _ReturnsViewState extends State<ReturnsView> {
  Returns? returns;
  Errors? errors;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    fetchReturns();
  }

  Future<void> fetchReturns() async {
    setState(() {
      isRefreshing = true;
    });

    dynamic data = await LibraryAPIService().getAllReturns();
    if (data is Returns) {
      setState(() {
        returns = data;
        isRefreshing = false;
      });
    } else if (data is Errors) {
      setState(() {
        errors = data;
        isRefreshing = false;
      });
    }
  }

  Future<void> refreshReturns() async {
    await fetchReturns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: returns != null
          ? RefreshIndicator(
              onRefresh: refreshReturns,
              child: ListView.builder(
                itemCount: returns!.data.length,
                itemBuilder: (context, index) {
                  ReturnData returnData = returns!.data[index];

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          returnData.bookName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const Text(
                            'Borrowed Date:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            returnData.borrowedDate,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Return Date:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            returnData.returnDate,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: isRefreshing
                  ? CircularProgressIndicator(
                      color: GlobalColors.mainColor,
                    )
                  : const Text("Failed to fetch returns."),
            ),
    );
  }
}
