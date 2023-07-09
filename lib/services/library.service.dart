import 'package:campus_connect_app/models/error.model.dart';
import 'package:campus_connect_app/models/library/bookInstances.model.dart';
import 'package:campus_connect_app/models/library/borrows.model.dart';
import 'package:campus_connect_app/models/library/returns.model.dart';
import 'package:campus_connect_app/models/success.model.dart';
import 'package:campus_connect_app/view/login.view.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../models/library/books.model.dart';
import "../utils/constants.dart";

class LibraryAPIService {
  Future<dynamic> getAllBooks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.booksEndpoint);
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http
          .get(url, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        Book books = bookFromJson(response.body);
        return books;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getAllBorrows() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.borrowsEndpoint);
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http
          .get(url, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        Borrows borrows = borrowsFromJson(response.body);
        return borrows;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getAllReturns() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.returnsEndpoint);
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http
          .get(url, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        Returns returns = returnsFromJson(response.body);
        return returns;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> returnBook(int borrowId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.returnBookEndpoint}$borrowId/");
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http
          .post(url, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        Success success = successFromJson(response.body);
        return success;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getAllBookInstances(int bookId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.bookInstancesEndpoint}$bookId/");
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http
          .get(url, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        BookInstance instances = bookInstanceFromJson(response.body);
        return instances;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> borrowBook(int bookInstanceId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.borrowBookEndpoint}$bookInstanceId/");
      Object? accessToken = prefs.get("accessToken");
      if (accessToken == null) {
        Get.off(() => const LoginView());
      }
      var response = await http
          .post(url, headers: {"Authorization": "Bearer $accessToken"});
      if (response.statusCode == 200) {
        Success success = successFromJson(response.body);
        return success;
      } else {
        Errors errors = errorsFromJson(response.body);
        return errors;
      }
    } catch (error) {
      rethrow;
    }
  }
}
