import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:debook/models/book.dart';

class ApiService {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';
  static String api = 'AIzaSyBXplompR9m5iIaX_2owN056QRARdKDQ2o';

  Future<List<Book>> fetchBooks() async {
    final response = await http.get(Uri.parse(
        '$_baseUrl?q=subject:?&maxResults=20&orderBy=newest&key=$api'));

    if (response.statusCode == 200) {
      final List<dynamic> items = json.decode(response.body)['items'];
      return items.map((item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<Book>> fetchBooksByCategory(String category) async {
    final response = await http
        .get(Uri.parse('$_baseUrl?q=subject:$category&maxResults=20&key=$api'));

    if (response.statusCode == 200) {
      final List<dynamic> items = json.decode(response.body)['items'];
      return items.map((item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load books for category $category');
    }
  }

  Future<List<Book>> fetchSearchResults(String query) async {
    final response = await http.get(
        Uri.parse('$_baseUrl?q=$query&maxResults=40&orderBy=newest&key=$api'));

    if (response.statusCode == 200) {
      final List<dynamic> items = json.decode(response.body)['items'];
      return items.map((item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load search results');
    }
  }
}
