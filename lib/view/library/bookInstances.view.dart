import 'package:flutter/material.dart';

import '../../models/error.model.dart';
import '../../models/library/bookInstances.model.dart';
import '../../models/success.model.dart';
import '../../services/library.service.dart';
import '../../utils/global.colors.dart';
import '../../utils/snackbar.dart';

// ignore: must_be_immutable
class BookInstancesView extends StatefulWidget {
  int bookId;
  BookInstancesView({required this.bookId, Key? key}) : super(key: key);

  @override
  State<BookInstancesView> createState() => _BookInstancesViewState();
}

class _BookInstancesViewState extends State<BookInstancesView> {
  BookInstance? bookInstances;
  Errors? errors;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    fetchBookInstances();
  }

  Future<void> fetchBookInstances() async {
    setState(() {
      isRefreshing = true;
    });

    dynamic data = await LibraryAPIService().getAllBookInstances(widget.bookId);
    if (data is BookInstance) {
      setState(() {
        bookInstances = data;
        isRefreshing = false;
      });
    } else if (data is Errors) {
      setState(() {
        errors = data;
        isRefreshing = false;
      });
    }
  }

  Future<void> refreshBookInstances() async {
    await fetchBookInstances();
  }

  Future<void> borrowBook(int borrowId) async {
    dynamic data = await LibraryAPIService().borrowBook(borrowId);
    if (data is Success) {
      generateSuccessSnackbar("Success", data.message);
    } else if (data is Errors) {
      generateErrorSnackbar("Error", data.message);
    }
    await fetchBookInstances();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Instances"),
        centerTitle: true,
        backgroundColor: GlobalColors.mainColor,
      ),
      body: bookInstances != null
          ? RefreshIndicator(
              onRefresh: refreshBookInstances,
              child: ListView.builder(
                itemCount: bookInstances!.data.length,
                itemBuilder: (context, index) {
                  BookInstanceData bookInstanceData =
                      bookInstances!.data[index];
                  bool isBorrowed = bookInstanceData.borrowed;

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
                          bookInstanceData.bookName,
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
                            'Book Number: ${bookInstanceData.bookNumber}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            isBorrowed
                                ? 'Status: Borrowed'
                                : 'Status: Not Borrowed',
                            style: TextStyle(
                              color: isBorrowed ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                      trailing: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            isBorrowed ? Colors.grey : Colors.green,
                          ),
                        ),
                        onPressed: isBorrowed
                            ? null
                            : () => borrowBook(bookInstanceData.id),
                        child: const Text('Borrow'),
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
                  : const Text("No book instances found!"),
            ),
    );
  }
}
