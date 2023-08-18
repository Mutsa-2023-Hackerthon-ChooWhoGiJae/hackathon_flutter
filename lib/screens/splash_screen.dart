import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mutsa_hackathon_2023/constants/palette.dart';
import 'package:mutsa_hackathon_2023/screens/main_screen.dart';

import 'logiin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2000), () {
      final _currentUser = FirebaseAuth.instance.currentUser;
      if (_currentUser != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool _isDesk = MediaQuery.of(context).size.width > 520;
    return Scaffold(
        backgroundColor: Palette.bgColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ],
          ),
        ));
  }
}
