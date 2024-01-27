import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'UploadVideoForm.dart';

class Video3m extends StatefulWidget {
  final VoidCallback flipCam;
  const Video3m({Key? key, required this.flipCam}) : super(key: key);

  @override
  State<Video3m> createState() => _Video3mState();
}

class _Video3mState extends State<Video3m> {
  bool isBeautyOn = false;
  File? _selectedFile;
  int timer = 0;

  final List<String> _iconPath = <String>[
    "assets/icons/timer3.png",
    "assets/icons/Timer5.png"
  ];

  /// record the video clicked on
  Future<void> _getVideo(ImageSource source) async {
    print("icon button pressed");
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(
      source: source,
      maxDuration: Duration(seconds: 180),
    );
    if (pickedFile != null) {
      // Instead of navigating to VideoUploadForm, you can handle the logic here
      // For example, you can set the _selectedFile and update the UI accordingly.
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
      // You can also perform any other actions here before or after recording.
      // Now, you can decide whether to navigate or perform other actions.
      // For example, navigate to VideoUploadForm after recording.
      Get.to(VideoUploadForm(videoFile: _selectedFile!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            width: 375.w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        blurRadius: 50.r,
                        offset: Offset(0, 0.33))
                  ]),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        size: 25.h,
                        color: Colors.white,
                      )),
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        blurRadius: 50.r,
                        offset: Offset(0, 0.33))
                  ]),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.music_note_outlined,
                            color: Colors.white,
                          )),
                      Text(
                        "Music",
                        style: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        blurRadius: 70.r,
                        offset: Offset(0, 0.33))
                  ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          IconButton(
                              onPressed: () async {
                                //Changing the Camera
                                widget.flipCam();
                              },
                              icon: Icon(Icons.flip_camera_android_outlined,
                                  size: 25.h, color: Colors.white)),
                          Text(
                            "Flip",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isBeautyOn = !isBeautyOn;
                              });
                            },
                            child: Image.asset(
                              (isBeautyOn)
                                  ? "assets/icons/BeautyOn.png"
                                  : "assets/icons/BeautyOff.png",
                              height: 20.h,
                              width: 20.h,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "Beauty",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              "assets/icons/Filters.png",
                              height: 20.h,
                              width: 20.h,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "Filters",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Column(
                        children: [
                          (timer == 0)
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      timer++;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.timer_off_outlined,
                                    size: 25.h,
                                    color: Colors.white,
                                  ))
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (timer != 2) {
                                        timer++;
                                      } else {
                                        timer = 0;
                                      }
                                    });
                                  },
                                  child: Image.asset(
                                    _iconPath[timer - 1],
                                    height: 20.h,
                                    width: 20.h,
                                  ),
                                ),
                          SizedBox(
                            height: (timer == 0) ? 0 : 5.h,
                          ),
                          Text(
                            "Timer",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Column(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.flash_off_sharp,
                                color: Colors.white,
                                size: 25.h,
                              )),
                          Text(
                            "Flash",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  Image.asset(
                    "assets/icons/effects.png",
                    height: 40.h,
                    width: 40.h,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "Effects",
                    style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Stack(alignment: Alignment.center, children: [
              Container(
                  margin: EdgeInsets.only(bottom: 70.h, right: 50.w),
                  child: IconButton(
                    icon: Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 90.r,
                    ),
                    onPressed: () {
                      // print("icon button pressed");
                      // _getVideo(ImageSource.camera);
                    },
                  )),
              Container(
                  margin: EdgeInsets.only(
                      bottom: 39.h, right: 22.w, top: 20.h, left: 22.w),
                  child: IconButton(
                    icon: Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 40.r,
                    ),
                    onPressed: () {
                      print("icon button pressed");
                      _getVideo(ImageSource.camera);
                    },
                  )),
            ]),
            GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  Image.asset(
                    "assets/icons/upload.png",
                    height: 40.h,
                    width: 40.h,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "Upload",
                    style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        )
      ],
    ));
  }
}
