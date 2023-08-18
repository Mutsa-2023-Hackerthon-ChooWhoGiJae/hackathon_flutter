import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mutsa_hackathon_2023/constants/palette.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.productId,
  });
  final String productId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '실시간 채팅',
          style: TextStyle(
            fontSize: 15.sp,
            color: Palette.blackColor,
          ),
        ),
      ),
      body: Container(),
    );
  }
}
