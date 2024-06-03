import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:debook/screens/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart'; // Assuming you have a HomePage

class WelcomePage extends StatefulWidget {
  static const nameRoute = '/welcomepage';
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null && username.isNotEmpty) {
      // User is already logged in, navigate to HomePage
      Navigator.pushReplacementNamed(context, BottomNavBar.nameRoute);
    } else {
      // No session, navigate to LoginPage after a delay
      await Future.delayed(Duration(seconds: 5));
      Navigator.pushReplacementNamed(context, LoginPage.nameRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 183, 84),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText(
                  'DeBooK',
                  textStyle: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
              isRepeatingAnimation: true,
              totalRepeatCount: 5,
            ),
            SizedBox(height: 50),
            SpinKitFadingCircle(
              color: Colors.white,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
