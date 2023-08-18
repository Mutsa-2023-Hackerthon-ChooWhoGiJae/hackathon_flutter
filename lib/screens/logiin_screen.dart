import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mutsa_hackathon_2023/constants/apis.dart';
import 'package:mutsa_hackathon_2023/screens/main_screen.dart';

import '../constants/palette.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    // googleProvider.setCustomParameters({'로그인 계정': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
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
            Image.asset(
              'assets/app_logo.png',
              width: 30.w,
              height: 30.w,
            ),
            SizedBox(
              height: _isDesk ? 50 : 50.w,
            ),
            ElevatedButton(
              onPressed: () async {
                await signInWithGoogle();
                // register to server
                final _currentUser = FirebaseAuth.instance.currentUser;

                if (_currentUser != null) {
                  final _client = Dio();
                  final _response = await _client.post(
                    Apis.baseRelease + '/user/register',
                    data: {
                      'email': _currentUser.email,
                      'displayName':
                          _currentUser.displayName ?? _currentUser.email,
                      'profileImage': _currentUser.photoURL ?? '',
                    },
                  );
                }

                if (FirebaseAuth.instance.currentUser != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen(),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('오류'),
                      content: Text('로그인에 실패했습니다. 잠시 후에 다시 시도해주세요.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('확인'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text(
                '구글 계정으로 로그인',
                style: TextStyle(fontSize: _isDesk ? 15 : 15.sp),
              ),
            ),
            SizedBox(
              height: _isDesk ? 10 : 10.w,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ),
                );
              },
              child: Text('로그인 없이 사용할래요'),
            )
          ],
        ),
      ),
    );
  }
}
