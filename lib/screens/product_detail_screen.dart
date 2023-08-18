import 'dart:js_interop';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mutsa_hackathon_2023/constants/apis.dart';
import 'package:mutsa_hackathon_2023/constants/gaps.dart';
import 'package:mutsa_hackathon_2023/constants/palette.dart';
import 'package:mutsa_hackathon_2023/screens/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domains/product_detail.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
  });
  final String productId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Future<ProductDetail> fetchProductDetail(String productId) async {
    try {
      final _client = Dio();
      final _response =
          await _client.get(Apis.baseRelease + '/product/${productId}');
      return ProductDetail.fromJson(_response.data);
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<void> _launchUrl(String url) async {
    final _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  final _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    bool _isDesk = MediaQuery.of(context).size.width > 520;
    if (_isDesk) {
      return Scaffold(
        body: Center(
          child: Text('모바일 사이즈에 최적화되어있어요. 모바일로 접속해주세요'),
        ),
      );
    }
    return Scaffold(
        backgroundColor: Palette.bgColor,
        appBar: AppBar(
          title: Text(
            '상품 상세 정보',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Palette.blackColor,
            ),
          ),
        ),
        body: FutureBuilder(
            future: fetchProductDetail(widget.productId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data == null) {
                return Center(
                  child: Text('상품 정보가 존재하지 않거나 삭제되었어요.'),
                );
              }

              // Align(
              //   alignment: Alignment.bottomLeft,
              //   child: Icon(
              //     Icons.favorite,
              //     color: Colors.red,
              //   ),
              // )
              return ListView(
                children: [
                  Image.network(
                    snapshot.data!.productImage,
                    height: 300.w,
                    fit: BoxFit.fitWidth,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 300.w,
                        alignment: Alignment.center,
                        color: Color(0xffeeeeee),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.grey),
                            Text(
                              '상품 이미지가 없어요.',
                              style: TextStyle(
                                color: Palette.blackColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30.h),
                        Text(
                          snapshot.data!.homeShopName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Palette.mainColor,
                          ),
                        ),
                        gap10h,
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              snapshot.data!.productName,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: Bounceable(
                                onTap: () => Future.delayed(
                                  Duration(milliseconds: 200),
                                  () {
                                    if (_currentUser.isNull) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: Text('로그인 후에 사용할 수 있어요.'),
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
                                    // add or remove from favorite
                                  },
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 25.w,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.w,
                        ),
                        Text(
                          snapshot.data!.broadcastDate +
                              ' ' +
                              snapshot.data!.broadcastTime +
                              ' 방송',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff888888),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Container(
                          width: double.infinity,
                          height: 80.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '최저가 - ${snapshot.data!.lowestShop}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Palette.blackColor,
                                ),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Text(
                                snapshot.data!.priceLowest.toString() + '원',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[900],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                        Bounceable(
                          onTap: () => Future.delayed(
                            Duration(milliseconds: 200),
                            () async {
                              await _launchUrl(snapshot.data!.lowestUrl);
                              // uri launcher
                            },
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 60.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Palette.mainColor,
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Text(
                              '최저가 구매하기',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        // if (snapshot.data!.broadcastDate ==
                        //     DateTime.now().toString().substring(0, 10))
                        Center(
                          child: Bounceable(
                            onTap: () =>
                                Future.delayed(Duration(milliseconds: 200), () {
                              if (_currentUser.isNull) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Text('로그인 후에 사용할 수 있어요.'),
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
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      productId: widget.productId,
                                    ),
                                  ),
                                );
                              }
                            }),
                            child: Text(
                              '실시간 대화 참여하기',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Palette.mainColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }));
  }
}
