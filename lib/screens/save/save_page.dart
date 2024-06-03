import 'package:flutter/material.dart';
import 'package:debook/screens/home/pages/book_details.dart';
import 'package:provider/provider.dart';
import 'package:debook/models/book_provider.dart';

class BookmarkPage extends StatelessWidget {
  static const nameRoute = '/bookmark';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          return FutureBuilder(
            future: bookProvider.fetchBooks(),
            builder: (context, snapshot) {
              if (bookProvider.books.isEmpty) {
                return Center(child: Text('No bookmarks yet.'));
              } else {
                return ListView.builder(
                  itemCount: bookProvider.books.length,
                  itemBuilder: (context, index) {
                    final book = bookProvider.books[index];
                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, BookDetail.nameRoute,
                            arguments: book);
                      },
                      leading: Image.network(book.thumbnail),
                      title: Text(book.title, overflow: TextOverflow.ellipsis),
                      subtitle: Text(book.authors),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          bookProvider.removeBook(book.id);
                        },
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
