import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Live.dart';
import 'Video15.dart';
import 'Video3m.dart';
import 'Video60.dart';

class CreateVideo extends StatefulWidget {
  const CreateVideo({super.key, required this.cameras});
  final List<CameraDescription> cameras;

  @override
  State<CreateVideo> createState() => _CreateState();
}

class _CreateState extends State<CreateVideo> {
  final PageController _controller = PageController();
  int pageIndex = 0;

  late CameraController controller;
  int cameraIndex = 1;

  //For Camera
  Future<void> accessCam() async {
    controller =
        CameraController(widget.cameras[cameraIndex], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    accessCam();
  }

  @override
  void dispose() async {
    await controller.dispose();
    super.dispose();
  }

  void flipCam() async {
    print("Flipping Camera");
    await controller.dispose();
    setState(() {
      cameraIndex = (cameraIndex == 0) ? 1 : 0;
      accessCam();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            CameraPreview(controller),
            PageView(
              pageSnapping: true,
              controller: _controller,
              onPageChanged: (i) {
                setState(() {
                  pageIndex = i;
                });
              },
              children: [
                Video15(flipCam: flipCam),
                // MySnapchatApp(),
                Video60(flipCam: flipCam),
                Video3m(flipCam: flipCam),
                Live(flipCam: flipCam)
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        color: Colors.black,
        child: Container(
          height: 50.h,
          padding: EdgeInsets.all(5.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _controller.animateToPage(0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
                child: Column(
                  children: [
                    Text(
                      "15s",
                      style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: (pageIndex == 0) ? Colors.white : Colors.grey),
                    ),
                    (pageIndex == 0)
                        ? Icon(
                            Icons.circle,
                            size: 5.h,
                            color: Colors.white,
                          )
                        : SizedBox()
                  ],
                ),
              ),
              SizedBox(width: 30.w),
              GestureDetector(
                onTap: () {
                  _controller.animateToPage(1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
                child: Column(
                  children: [
                    Text(
                      "60s",
                      style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: (pageIndex == 1) ? Colors.white : Colors.grey),
                    ),
                    (pageIndex == 1)
                        ? Icon(
                            Icons.circle,
                            size: 5.h,
                            color: Colors.white,
                          )
                        : SizedBox()
                  ],
                ),
              ),
              SizedBox(width: 30.w),
              GestureDetector(
                  onTap: () {
                    _controller.animateToPage(2,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                  child: Column(
                    children: [
                      Text(
                        "3m",
                        style: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                (pageIndex == 2) ? Colors.white : Colors.grey),
                      ),
                      (pageIndex == 2)
                          ? Icon(
                              Icons.circle,
                              size: 5.h,
                              color: Colors.white,
                            )
                          : SizedBox()
                    ],
                  )),
              SizedBox(width: 30.w),
              GestureDetector(
                  onTap: () {
                    _controller.animateToPage(3,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  },
                  child: Column(
                    children: [
                      Text(
                        "Live",
                        style: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                (pageIndex == 3) ? Colors.white : Colors.grey),
                      ),
                      (pageIndex == 3)
                          ? Icon(
                              Icons.circle,
                              size: 5.h,
                              color: Colors.white,
                            )
                          : SizedBox(),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
