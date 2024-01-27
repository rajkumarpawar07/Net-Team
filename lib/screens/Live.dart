import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Live extends StatefulWidget {
  final VoidCallback flipCam;
  const Live({Key? key, required this.flipCam}) : super(key: key);

  @override
  State<Live> createState() => _LiveState();
}

class _LiveState extends State<Live> {
  bool isBeautyOn = false;
  bool isLive = false;
  int timer = 0;

  final List<LiveChat> _chatList = <LiveChat>[
    LiveChat(
        userName: "iamraj",
        imageUrl: "assets/images/profile1.png",
        chat: "Hi bro"),
    LiveChat(
        userName: "iamkumar",
        imageUrl: "assets/images/profile2.png",
        chat: "Hi, Love from India"),
    LiveChat(
        userName: "iamresin",
        imageUrl: "assets/images/profile3.png",
        chat: "Hi bro, Love from Sydney")
  ];

  TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void addText() {
    if (_textEditingController.text != '') {
      setState(() {
        _chatList.add(LiveChat(
            userName: "iamaswin",
            imageUrl: "assets/images/profile4.png",
            chat: _textEditingController.text));
      });
      _textEditingController.text = '';
      FocusScope.of(context).unfocus();
      _scrollToBottom();
    }
  }

  final List<String> _iconPath = <String>[
    "assets/icons/timer3.png",
    "assets/icons/Timer5.png"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //Debugging
            //color: Colors.red,
            child: SizedBox(
                width: 375.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isLive
                        ? Container(
                            margin: EdgeInsets.all(5.h),
                            height: 30.h,
                            width: 100.w,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red)),
                              child: Text(
                                'End Live',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                setState(() {
                                  isLive = false;
                                });
                              },
                            ),
                          )
                        : Container(
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
          ),
          Container(
            //color: Colors.blue,
            child: isLive
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 200.h,
                        width: 375.w,
                        //color: Colors.amber,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _chatList.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            LiveChat message = _chatList[index];
                            return Padding(
                              padding: EdgeInsets.all(5.h),
                              child: Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 40.h,
                                      child: CircleAvatar(
                                        radius: 20.r,
                                        backgroundImage: AssetImage(
                                          message.imageUrl,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "@${message.userName}",
                                          style: GoogleFonts.roboto(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "${message.chat}",
                                          style: GoogleFonts.roboto(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 50.h,
                        width: 350.w,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.r),
                            border: Border.all(color: Colors.white)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                maxLengthEnforcement: MaxLengthEnforcement.none,
                                controller: _textEditingController,
                                onSubmitted: (val) {
                                  addText();
                                },
                                decoration: InputDecoration(
                                    hintText: 'Type a Message',
                                    hintStyle: GoogleFonts.roboto(
                                        fontSize: 15.sp,
                                        color: const Color(0xFFB6B7B8),
                                        fontWeight: FontWeight.bold),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromRGBO(0, 0, 0, 0)),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent))),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            VerticalDivider(
                              color: const Color(0xFFB6B7B8),
                              width: 1.h,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            IconButton(
                                onPressed: () {
                                  print("HI");
                                  addText();
                                },
                                icon: Icon(
                                  Icons.send_outlined,
                                  size: 20.h,
                                  color: const Color(0xFF491BBA),
                                ))
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: 50.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.r),
                      child: SizedBox(
                        height: 50.h,
                        width: 200.h,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLive = !isLive;
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF00E9F7))),
                          child: Text(
                            "Go Live",
                            style: GoogleFonts.roboto(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}

class LiveChat {
  String userName;
  String imageUrl;
  String chat;
  LiveChat(
      {required this.userName, required this.imageUrl, required this.chat});
}
