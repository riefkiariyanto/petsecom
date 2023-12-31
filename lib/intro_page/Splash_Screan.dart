import 'package:flutter/material.dart';
import 'package:petsecom/Views/HomePage.dart';
import 'package:petsecom/Views/LoginPage.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScrean extends StatefulWidget {
  const SplashScrean({super.key});

  @override
  State<SplashScrean> createState() => _SplashScreanState();
}

class _SplashScreanState extends State<SplashScrean> {
  @override
  void initState() {
    super.initState();
    startLaunching();

    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void startLaunching() async {
    final prefs = await SharedPreferences.getInstance();
    bool slogin = prefs.getBool('slogin') ?? false;
    bool sregister = prefs.getBool('sregister') ?? false;

    if (slogin || sregister) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Center(
        child: new Image(
          image: AssetImage("images/Login.PNG"),
        ),
      ),
    );
  }
}
