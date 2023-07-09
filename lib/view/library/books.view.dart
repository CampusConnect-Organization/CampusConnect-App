import 'package:campus_connect_app/view/library/bookInstances.view.dart';
import 'package:flutter/material.dart';

import '../../models/error.model.dart';
import '../../models/library/books.model.dart';
import '../../services/library.service.dart';
import '../../utils/global.colors.dart';
import 'package:get/get.dart';

class BooksView extends StatefulWidget {
  const BooksView({Key? key}) : super(key: key);

  @override
  State<BooksView> createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  Book? books;
  Errors? errors;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    setState(() {
      isRefreshing = true;
    });

    dynamic data = await LibraryAPIService().getAllBooks();
    if (data is Book) {
      setState(() {
        books = data;
        isRefreshing = false;
      });
    } else if (data is Errors) {
      setState(() {
        errors = data;
        isRefreshing = false;
      });
    }
  }

  Future<void> refreshBooks() async {
    await fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: books != null
          ? RefreshIndicator(
              onRefresh: refreshBooks,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: books!.data.length,
                  itemBuilder: (context, index) {
                    List<BookData>? booksList = books?.data;
                    var currentItem = booksList?[index];

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(currentItem?.title ?? ''),
                            subtitle: Text(
                                'Author: ${currentItem?.author ?? ''}\nCategory: ${currentItem?.category ?? ''}'),
                            trailing: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      GlobalColors.mainColor)),
                              onPressed: () {
                                Get.to(() =>
                                    BookInstancesView(bookId: currentItem!.id));
                                // Handle the open button press
                                // You can add your custom logic here
                              },
                              child: const Text('Open'),
                            ),
                          ),
                          const Divider(),
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
                  : const Text("Failed to fetch books."),
            ),
    );
  }
}
