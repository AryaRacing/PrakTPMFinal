import 'package:flutter/material.dart';
import '/database/db_helper.dart';
import '/models/book.dart';
import '/models/book_provider.dart';
import '/themes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetail extends StatelessWidget {
  static const nameRoute = '/bookDetails';
  const BookDetail({Key? key}) : super(key: key);

  Future<void> saveBook(Book book) async {
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.create(book);
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Book data = ModalRoute.of(context)?.settings.arguments as Book;

    Widget header() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        margin: const EdgeInsets.only(top: 30, bottom: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.chevron_left_rounded, size: 30)),
            Text(
              'Book Details',
              style: semiBoldText14.copyWith(
                color: blackColor,
              ),
            ),
            const Icon(Icons.share_outlined)
          ],
        ),
      );
    }

    Widget bookImage() {
      return Hero(
        tag: data.thumbnail,
        child: Container(
          height: 267,
          width: 175,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(data.thumbnail),
            ),
          ),
        ),
      );
    }

    Widget infoDescription() {
      return Container(
        height: 60,
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: greyColorInfo,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Rating',
                  style: mediumText10.copyWith(color: dividerColor),
                ),
                const SizedBox(height: 2),
                Text(
                  data.rating.toString(),
                  style: semiBoldText12.copyWith(color: blackColor2),
                ),
              ],
            ),
            VerticalDivider(color: dividerColor, thickness: 1),
            Column(
              children: [
                Text(
                  'Number of pages',
                  style: mediumText10.copyWith(color: dividerColor),
                ),
                const SizedBox(height: 2),
                Text(
                  '${data.pageCount} Page',
                  style: semiBoldText12.copyWith(color: blackColor2),
                ),
              ],
            ),
            VerticalDivider(color: dividerColor, thickness: 1),
            Column(
              children: [
                Text(
                  'Language',
                  style: mediumText10.copyWith(color: dividerColor),
                ),
                const SizedBox(height: 2),
                Text(
                  data.language.toUpperCase(),
                  style: semiBoldText12.copyWith(color: blackColor2),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget saveButton() {
      return Positioned(
        top: 400,
        right: 30,
        child: Container(
          height: 50,
          width: 50,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(color: greenColor, shape: BoxShape.circle),
          child: GestureDetector(
            onTap: () {
              final bookProvider =
                  Provider.of<BookProvider>(context, listen: false);
              bookProvider.addBook(
                Book(
                  id: data.id,
                  thumbnail: data.thumbnail,
                  title: data.title,
                  authors: data.authors,
                  description: data.description,
                  rating: data.rating,
                  pageCount: data.pageCount,
                  language: data.language,
                  previewLink: data.previewLink,
                  accessViewStatus: data.accessViewStatus,
                ),
              );
            },
            child: Image.asset('assets/icons/icon-save-nav.png'),
            // child: Container(
            //   height: 50,
            //   width: 50,
            //   padding: const EdgeInsets.symmetric(vertical: 16),
            //   decoration:
            //       BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            //   child: Icon(Icons.save, color: Colors.white),
            // ),
          ),
        ),
      );
    }

    Widget bottonReadNow() {
      return Container(
        height: 50,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: TextButton(
          onPressed: () {
            _launchURL(data.previewLink);
          },
          style: TextButton.styleFrom(
            backgroundColor: greenColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            'Read Now',
            style: semiBoldText20.copyWith(color: whiteColor),
          ),
        ),
      );
    }

    Widget description() {
      return Container(
        margin: const EdgeInsets.only(top: 50),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        style: semiBoldText20.copyWith(color: blackColor2),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        data.authors,
                        style: mediumText14.copyWith(color: greyColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  data.accessViewStatus,
                  style: mediumText14.copyWith(color: greenColor),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'Description',
              style: semiBoldText14.copyWith(color: blackColor2),
            ),
            const SizedBox(height: 6),
            Text(
              data.description,
              style: regularText12.copyWith(color: greyColor),
            ),
            infoDescription(),
            bottonReadNow(),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: ListView(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  header(),
                  bookImage(),
                  description(),
                ],
              ),
              saveButton(),
            ],
          )
        ],
      ),
    );
  }
}
