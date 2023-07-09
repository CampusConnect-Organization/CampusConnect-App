import 'package:campus_connect_app/utils/global.colors.dart';
import 'package:campus_connect_app/view/home.view.dart';
import 'package:campus_connect_app/view/library/books.view.dart';
import 'package:campus_connect_app/view/library/borrows.view.dart';
import 'package:campus_connect_app/view/library/returns.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  int pageIndex = 0;

  final pages = [const BooksView(), const BorrowsView(), const ReturnsView()];

  void onItemTapped(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Library Section"),
        centerTitle: true,
        backgroundColor: GlobalColors.mainColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.off(() => const HomeView()),
        ),
      ),
      body: pages.elementAt(pageIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "All Books"),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book), label: "My Borrows"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_rounded), label: "My Returns")
        ],
        elevation: 0,
        currentIndex: pageIndex,
        selectedItemColor: GlobalColors.mainColor,
        onTap: onItemTapped,
      ),
    );
  }
}
