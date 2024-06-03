import 'package:flutter/material.dart';
import 'package:debook/API/api_service.dart';
import 'package:debook/models/book.dart';
import 'package:debook/screens/home/components/trending_book.dart';

class SearchPage extends StatefulWidget {
  static const nameRoute = '/searchPage';
  final String query;

  const SearchPage({Key? key, required this.query}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ApiService _apiService = ApiService();
  List<Book> _searchResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSearchResults(widget.query);
  }

  Future<void> _fetchSearchResults(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final books = await _apiService.fetchSearchResults(query);
      setState(() {
        _searchResults = books;
        _isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "${widget.query}"'),
      ),
      body: ListView(
        children: [
          Container(
            child: Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : TrendingBooksGrid(
                      books: _searchResults,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
