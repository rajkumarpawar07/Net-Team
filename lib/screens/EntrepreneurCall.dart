import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EntrepreneurCall extends StatefulWidget {
  const EntrepreneurCall({Key? key}) : super(key: key);

  @override
  State<EntrepreneurCall> createState() => _EntrepreneurCallState();
}

class _EntrepreneurCallState extends State<EntrepreneurCall> {
  bool isConnected = false;
  int _imageIndex = 0;
  final List<String> _imagePaths = <String>[
    'assets/images/profile1.png',
    'assets/images/profile2.png',
    'assets/images/profile3.png',
    'assets/images/profile4.png',
    'assets/images/profile5.png',
    'assets/images/profile6.png',
    'assets/images/profile7.png',
    'assets/images/profile8.png',
    'assets/images/profile9.png',
    'assets/images/profile10.png',
  ];
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (Timer timer) {
      if (_imageIndex < _imagePaths.length - 1) {
        setState(() {
          _imageIndex++;
        });
      } else {
        _timer.cancel();
        setState(() {
          isConnected = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF0E0B1F),
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 275.h,
                        width: 335.w,
                        decoration: BoxDecoration(
                            color: const Color(0xFF616161),
                            borderRadius: BorderRadius.circular(10.r)),
                        child: isConnected
                            ? Image.asset(
                                "assets/images/connected.png",
                                fit: BoxFit.cover,
                              )
                            : CircleAvatar(
                                radius: 40.r,
                                child: Image.asset(_imagePaths[_imageIndex]),
                              ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(10.w, 10.h, 0, 0),
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        height: 35.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                            color: const Color(0xFF030303).withOpacity(0.65),
                            borderRadius: BorderRadius.circular(20.r)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.videocam,
                              color: Colors.red,
                              size: 20.h,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "0:30",
                              style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 35.h,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 275.h,
                    width: 375.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF616161),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Image.asset(
                      "assets/images/entrepreneur.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 40.h,
                        width: 100.w,
                        child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Color(0xFFCBFB5E))),
                            onPressed: () {},
                            child: Text(
                              "Extend 5 mins",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                  color: Colors.black),
                            )),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      SizedBox(
                        height: 40.h,
                        width: 100.w,
                        child: ElevatedButton(
                            style: const  ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Color(0xFFEEEEEE))),
                            onPressed: () {},
                            child: Text(
                              "Allow Chat",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                  color: Colors.black),
                            )),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      SizedBox(
                        height: 40.h,
                        width: 100.w,
                        child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Color(0xFFFF4E4E))),
                            onPressed: () {},
                            child: Text(
                              "End",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                  color: Colors.black),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0.0,
          color: const Color(0xFF0E0B1F),
          child: SizedBox(
            height: 60.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: SizedBox(
                      height: 40.h,
                      child: Icon(Icons.home,
                          size: 30.h, color: const Color(0xFFFFFFFF))),
                  onTap: () {
                    Navigator.pushNamed(context, "/");
                  },
                ),
                GestureDetector(
                  child: SizedBox(
                      height: 40.h,
                      child: Icon(Icons.videocam_rounded,
                          size: 30.h, color: const Color(0xFFCBFB5E))),
                  onTap: () {
                    //Navigate to Video Call
                  },
                ),
                GestureDetector(
                  child: SizedBox(
                      height: 40.h,
                      child: Icon(Icons.add_circle_rounded,
                          size: 30.h, color: const Color(0xFFFFFFFF))),
                  onTap: () {
                    //Navigate to Add tiktok
                  },
                ),
                GestureDetector(
                  child: SizedBox(
                      height: 40.h,
                      child: Icon(Icons.chat_bubble,
                          size: 30.h, color: const Color(0xFFFFFFFF))),
                  onTap: () {
                    //Navigate to chat
                  },
                ),
                GestureDetector(
                  child: SizedBox(
                      height: 40.h,
                      child: Icon(Icons.account_circle,
                          size: 30.h, color: const Color(0xFFFFFFFF))),
                  onTap: () {
                    //Navigate to Account section
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
