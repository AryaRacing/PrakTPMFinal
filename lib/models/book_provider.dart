import 'package:flutter/material.dart';
import '/database/db_helper.dart';
import '/models/book.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];

  List<Book> get books => _books;

  Future<void> fetchBooks() async {
    final data = await DatabaseHelper.instance.readAllBooks();
    _books = data;
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    await DatabaseHelper.instance.create(book);
    await fetchBooks();
  }

  Future<void> removeBook(String id) async {
    await DatabaseHelper.instance.delete(id);
    await fetchBooks();
  }
}
