import 'package:debook/screens/bottom_nav_bar.dart';
import 'package:debook/screens/home/pages/login_page.dart';
import 'package:debook/screens/home/pages/register_page.dart';
import 'package:debook/screens/save/save_page.dart';
import 'package:flutter/material.dart';
import 'package:debook/screens/home/pages/welcome_page.dart';
import 'models/book_provider.dart';
import 'screens/home/home_page.dart';
import 'screens/home/pages/book_details.dart';
import 'screens/home/pages/search_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookProvider()),
      ],
      child: MaterialApp(
        title: 'DeBooK',
        debugShowCheckedModeBanner: false,
        routes: {
          // HomePage.nameRoute: (context) => WelcomePage(),
          // BookDetail.nameRoute: (context) => const BookDetail(),
          // SearchPage.nameRoute: (context) => const SearchPage(query: ''),
          WelcomePage.nameRoute: (context) => WelcomePage(),
          LoginPage.nameRoute: (context) => LoginPage(),
          RegisterPage.nameRoute: (context) => RegisterPage(),
          BottomNavBar.nameRoute: (context) => const BottomNavBar(),
          HomePage.nameRoute: (context) => const HomePage(),
          BookDetail.nameRoute: (context) => const BookDetail(),
          BookmarkPage.nameRoute: (context) => BookmarkPage(),
          SearchPage.nameRoute: (context) => const SearchPage(query: ''),
        },
        initialRoute: WelcomePage.nameRoute,
      ),
    );
  }
}
