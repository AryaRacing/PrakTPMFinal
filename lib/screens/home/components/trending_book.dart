import 'package:flutter/material.dart';
import '/models/book.dart';
import '../pages/book_details.dart';
import '/themes.dart';

class TrendingBook extends StatelessWidget {
  const TrendingBook({
    Key? key,
    required this.info,
  }) : super(key: key);

  final Book info;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, BookDetail.nameRoute, arguments: info);
          },
          child: Container(
            height: 180,
            width: 160,
            margin: const EdgeInsets.only(top: 12, right: 20, left: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(info.thumbnail),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 160,
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              info.authors,
              style: mediumText12.copyWith(color: greyColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        SizedBox(
          width: 160,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 30,
            ),
            child: Text(
              info.title,
              style: semiBoldText14.copyWith(color: blackColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

class TrendingBooksGrid extends StatelessWidget {
  final List<Book> books;

  const TrendingBooksGrid({
    Key? key,
    required this.books,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two columns
        childAspectRatio: 0.7, // Adjust as needed
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return TrendingBook(info: books[index]);
      },
    );
  }
}
