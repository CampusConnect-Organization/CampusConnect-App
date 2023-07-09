import 'package:campus_connect_app/models/success.model.dart';
import 'package:campus_connect_app/utils/snackbar.dart';
import 'package:flutter/material.dart';

import '../../models/error.model.dart';
import '../../models/library/borrows.model.dart';
import '../../services/library.service.dart';
import '../../utils/global.colors.dart';

class BorrowsView extends StatefulWidget {
  const BorrowsView({Key? key}) : super(key: key);

  @override
  State<BorrowsView> createState() => _BorrowsViewState();
}

class _BorrowsViewState extends State<BorrowsView> {
  Borrows? borrows;
  Errors? errors;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    fetchBorrows();
  }

  Future<void> fetchBorrows() async {
    setState(() {
      isRefreshing = true;
    });

    dynamic data = await LibraryAPIService().getAllBorrows();
    if (data is Borrows) {
      setState(() {
        borrows = data;
        isRefreshing = false;
      });
    } else if (data is Errors) {
      setState(() {
        errors = data;
        isRefreshing = false;
      });
    }
  }

  Future<void> refreshBorrows() async {
    await fetchBorrows();
  }

  Future<void> returnBook(int borrowId) async {
    dynamic data = await LibraryAPIService().returnBook(borrowId);
    if (data is Success) {
      generateSuccessSnackbar("Success", data.message);
    } else if (data is Errors) {
      generateErrorSnackbar("Error", data.message);
    }
    await fetchBorrows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: borrows != null
          ? RefreshIndicator(
              onRefresh: refreshBorrows,
              child: ListView.builder(
                itemCount: borrows!.data.length,
                itemBuilder: (context, index) {
                  BorrowData borrowData = borrows!.data[index];
                  bool canReturnBook = !borrowData.returned;

                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                          borrowData.bookName,
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
                          Text(
                            'Book Code: ${borrowData.bookCode}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Borrow Date: ${borrowData.borrowDate}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            borrowData.returned
                                ? 'Status: Returned'
                                : 'Status: Not Returned',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: borrowData.returned
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: canReturnBook
                              ? const MaterialStatePropertyAll(Colors.green)
                              : const MaterialStatePropertyAll(Colors.grey),
                        ),
                        onPressed: canReturnBook
                            ? () => returnBook(borrowData.id)
                            : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          child: const Text(
                            'Return',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                  : const Text("Failed to fetch borrows."),
            ),
    );
  }
}
