import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mutsa_hackathon_2023/constants/apis.dart';
import 'package:mutsa_hackathon_2023/constants/gaps.dart';
import 'package:mutsa_hackathon_2023/constants/palette.dart';
import 'package:mutsa_hackathon_2023/screens/logiin_screen.dart';
import 'package:mutsa_hackathon_2023/screens/product_detail_screen.dart';

import '../domains/product.dart';
import '../domains/product_detail.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

var _selectedFilters = ["현대홈쇼핑", "홈앤쇼핑", "롯데홈쇼핑", "NS홈쇼핑"];

Future<List<Product>> fetchProducts(String formattedDate) async {
  try {
    final _client = Dio();
    final _response =
        await _client.get(Apis.getProducts + '?broadcastDate=$formattedDate');

    final _result =
        (_response.data as List).map((e) => Product.fromJson(e)).toList();
    _result.sort((a, b) => compareBroadTimes(a.broadcastTime, b.broadcastTime));
    return _result;
  } catch (e) {
    print(e);
    throw Exception();
  }
}

Future<List<ProductDetail>> fetchWishList(String userId) async {
  try {
    final _client = Dio();
    final _response =
        await _client.get(Apis.baseRelease + '/wishlist/${userId}');

    final _result =
        (_response.data as List).map((e) => ProductDetail.fromJson(e)).toList();
    return _result;
  } catch (e) {
    print(e);
    throw Exception();
  }
}

// compare boroadcastTime
compareBroadTimes(String time1, String time2) {
  List<String> parts = time1.split(" ");
  String hourString = parts[0];
  hourString = hourString.split('시')[0];
  String minuteString = parts[1];
  minuteString = minuteString.split('분')[0];

// Convert the hour and the minutes to integers.
  // if (hourString.length == 1) hourString = '0' + hourString;
  int hour = int.parse(hourString);
  int minute = int.parse(minuteString);

// Create a DateTime object from the hour and the minutes.
  DateTime dateTime1 = DateTime(2023, 8, 18, hour, minute);

// Create another DateTime object.

  List<String> parts2 = time2.split(" ");
  String hourString2 = parts2[0];
  hourString2 = hourString2.split('시')[0];
  String minuteString2 = parts2[1];
  minuteString2 = minuteString2.split('분')[0];

// Convert the hour and the minutes to integers.
  int hour2 = int.parse(hourString2);
  int minute2 = int.parse(minuteString2);

  DateTime dateTime2 = DateTime(2023, 8, 19, hour2, minute2);

// Compare the two DateTime objects.
  return dateTime1.compareTo(dateTime2);

// If dateTime1 is before dateTime2, the comparison result will be negative.
// If dateTime1 is after dateTime2, the comparison result will be positive.
// If dateTime1 is equal to dateTime2, the comparison result will be 0.
}

var _currentTap = 0;

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    bool _isDesk = MediaQuery.of(context).size.width > 520;
    final _currentUser = FirebaseAuth.instance.currentUser;
    if (_isDesk) {
      return Scaffold(
        body: Center(child: Text('모바일 사이즈에 최적화되어있어요. 모바일로 접속해주세요')),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Palette.bgColor,
        appBar: AppBar(
          backgroundColor: Palette.bgColor,
          elevation: 1,
          title: Image.asset(
            'assets/app_logo.png',
            fit: BoxFit.cover,
            width: 30.w,
            height: 30.w,
          ),
        ),
        drawer: Drawer(
          backgroundColor: Palette.bgColor,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Palette.mainColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_currentUser != null)
                      Text(
                        '안녕하세요, ${_currentUser.displayName}님!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    Text(
                      '오늘도 합리적인 쇼핑하세요!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.home_rounded,
                ),
                title: Text(
                  '홈쇼핑 편성표',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Palette.blackColor,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _currentTap = 0;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.person_rounded,
                ),
                title: Text(
                  '마이페이지',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Palette.blackColor,
                  ),
                ),
                onTap: () {
                  if (_currentUser != null) {
                    setState(() {
                      _currentTap = 1;
                    });
                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('오류'),
                        content: Text('로그인이 필요한 서비스입니다.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return LoginScreen();
                                },
                              ));
                            },
                            child: Text('확인'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('취소'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        body: _currentTap == 0
            ? Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gap10h,
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Text(
                        '맞춤형 필터',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Palette.blackColor,
                        ),
                      ),
                    ),
                    gap10h,
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Wrap(
                        children: [
                          FilterChipWidget(
                            title: '현대홈쇼핑',
                            onTap: () {
                              if (_selectedFilters.contains('현대홈쇼핑')) {
                                setState(() {
                                  _selectedFilters.remove('현대홈쇼핑');
                                });
                              } else {
                                setState(() {
                                  _selectedFilters.add('현대홈쇼핑');
                                });
                              }
                            },
                            isSelected: _selectedFilters.contains('현대홈쇼핑'),
                          ),
                          FilterChipWidget(
                            title: '홈앤쇼핑',
                            onTap: () {
                              if (_selectedFilters.contains('홈앤쇼핑')) {
                                setState(() {
                                  _selectedFilters.remove('홈앤쇼핑');
                                });
                              } else {
                                setState(() {
                                  _selectedFilters.add('홈앤쇼핑');
                                });
                              }
                            },
                            isSelected: _selectedFilters.contains('홈앤쇼핑'),
                          ),
                          FilterChipWidget(
                            title: '롯데홈쇼핑',
                            onTap: () {
                              if (_selectedFilters.contains('롯데홈쇼핑')) {
                                setState(() {
                                  _selectedFilters.remove('롯데홈쇼핑');
                                });
                              } else {
                                setState(() {
                                  _selectedFilters.add('롯데홈쇼핑');
                                });
                              }
                            },
                            isSelected: _selectedFilters.contains('롯데홈쇼핑'),
                          ),
                          FilterChipWidget(
                            title: 'NS홈쇼핑',
                            onTap: () {
                              if (_selectedFilters.contains('NS홈쇼핑')) {
                                setState(() {
                                  _selectedFilters.remove('NS홈쇼핑');
                                });
                              } else {
                                setState(() {
                                  _selectedFilters.add('NS홈쇼핑');
                                });
                              }
                            },
                            isSelected: _selectedFilters.contains('NS홈쇼핑'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    FutureBuilder(
                        future: fetchProducts('2023-08-17'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          //with snapshots
                          if (snapshot.data == null)
                            return Container(
                              child: Center(
                                child: Text('데이터를 불러올 수 없어요.'),
                              ),
                            );
                          return Expanded(
                              child: ListView(
                            children: [
                              ...snapshot.data!
                                  .where((e) =>
                                      _selectedFilters.contains(e.homeShopName))
                                  .map((e) => Bounceable(
                                        onTap: () => Future.delayed(
                                            Duration(milliseconds: 200), () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              return ProductDetailScreen(
                                                productId: e.productId,
                                              );
                                            }),
                                          );
                                        }),
                                        child: Container(
                                          width: 158.w,
                                          height: 300.h,
                                          margin: EdgeInsets.only(
                                            left: 16.w,
                                            right: 16.w,
                                            bottom: 16.h,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white,
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.w),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.network(
                                                        e.productImage,
                                                        width: 150.w,
                                                        height: 150.w,
                                                        fit: BoxFit.cover,
                                                        scale: 1.0,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object
                                                                    exception,
                                                                StackTrace?
                                                                    stackTrace) {
                                                      return Container(
                                                        width: 150.w,
                                                        height: 150.w,
                                                        alignment:
                                                            Alignment.center,
                                                        color:
                                                            Color(0xffeeeeee),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(Icons.error,
                                                                color: Colors
                                                                    .grey),
                                                            Text(
                                                              '상품 이미지가 없어요.',
                                                              style: TextStyle(
                                                                color: Palette
                                                                    .blackColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                                    SizedBox(
                                                      height: 8.h,
                                                    ),
                                                    Text(
                                                      e.productName,
                                                      textAlign:
                                                          TextAlign.center,
                                                      softWrap: true,
                                                      style: TextStyle(
                                                        color:
                                                            Palette.blackColor,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Text(
                                                      '방송 시간 : ' +
                                                          e.broadcastTime,
                                                      softWrap: true,
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color:
                                                            Color(0xff444444),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Palette.mainColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(15),
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w,
                                                    vertical: 10.w,
                                                  ),
                                                  margin: EdgeInsets.only(
                                                    left: 10.w,
                                                    top: 10.w,
                                                  ),
                                                  child: Text(
                                                    e.homeShopName,
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ],
                          ));
                        })
                  ],
                ),
              )
            : Container(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    Container(
                      width: 80.w,
                      height: 80.w,
                      child: Image.network(
                        '',
                        errorBuilder: (context, error, stack) => Icon(
                          Icons.person_rounded,
                          size: 60.w,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      // set image url
                      radius: 80.r,
                      child: Icon(
                        Icons.person_rounded,
                        size: 60.w,
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Text(
                      '${_currentUser!.displayName}님',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            '정보 수정',
                          ),
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Palette.mainColor),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return LoginScreen();
                                },
                              ),
                            );
                          },
                          child: Text('로그아웃'),
                        )
                      ],
                    ),
                    Expanded(
                      child: FutureBuilder(
                          // fetch user's wishlist
                          future: null,
                          builder: (context, snapshot) {
                            return ListView(
                              children: [
                                Container(
                                    width: double.infinity,
                                    height: 60.h,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Image.network('productImageUrl'),
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'shop name',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Palette.mainColor,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 4.h,
                                            ),
                                            Text(
                                              'product Name',
                                              style: TextStyle(
                                                color: Palette.blackColor,
                                                fontSize: 20.sp,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ))
                              ],
                            );
                          }),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  const FilterChipWidget({
    super.key,
    required this.isSelected,
    required this.onTap,
    this.title = 'NS홈쇼핑',
  });
  final bool isSelected;
  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () => Future.delayed(Duration(milliseconds: 200), onTap),
      child: Container(
        padding: EdgeInsets.all(6.w),
        margin: EdgeInsets.only(right: 5.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 1,
            color: isSelected ? Palette.mainColor : Colors.grey,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
