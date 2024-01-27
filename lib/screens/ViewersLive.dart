import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Live.dart';

class ViewersLive extends StatefulWidget {
  const ViewersLive({super.key});

  @override
  State<ViewersLive> createState() => _ViewersLiveState();
}

class PremiumChat extends LiveChat {
  bool isPremium;
  bool isSticker;
  String stickerPath;
  PremiumChat({
    required String userName,
    required String imageUrl,
    required String chat,
    required this.isPremium,
    required this.isSticker,
    required this.stickerPath,
  }) : super(userName: userName, imageUrl: imageUrl, chat: chat);
}

class SuperPremiumChat extends PremiumChat {
  Duration duration;
  SuperPremiumChat(
      {required this.duration,
      required String userName,
      required String imageUrl,
      required String chat,
      required bool isPremium,
      required bool isSticker,
      required String stickerPath})
      : super(
            userName: userName,
            imageUrl: imageUrl,
            chat: chat,
            isPremium: isPremium,
            isSticker: isSticker,
            stickerPath: stickerPath);
}

class _ViewersLiveState extends State<ViewersLive> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _premiumScrollController = ScrollController();
  bool isLiked = false;

  final List<SuperPremiumChat> _superPremiumChatList = [];

  final List<dynamic> _chatList = <dynamic>[
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
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (mounted) {
          // Check again before scrolling to avoid calling setState on a disposed widget
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void addBasicPremiumChat(PremiumChat chat) {
    setState(() {
      _chatList.add(chat);
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (mounted) {
        // Check again before scrolling to avoid calling setState on a disposed widget
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void addSuperPremiumChat(SuperPremiumChat chat) {
    setState(() {
      _superPremiumChatList.add(chat);
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (mounted) {
        // Check again before scrolling to avoid calling setState on a disposed widget
        _premiumScrollController.animateTo(
          _premiumScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Should be later converted to live video part
          SizedBox(
            height: MediaQuery.of(context)!.size.height,
            width: MediaQuery.of(context)!.size.width,
            child: Image.asset(
              'assets/images/liveSample.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10)
                      ]),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                            radius: 17,
                            backgroundImage:
                                AssetImage('assets/images/profile1.png'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "iamjulie",
                            style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 32.h,
                          width: 60.w,
                          decoration: const BoxDecoration(
                              color: Color(0xFF1EA7D7),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: Center(
                            child: Text(
                              "Live",
                              style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 32.h,
                          width: 60.w,
                          decoration: const BoxDecoration(
                              color: Colors.black26,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.visibility_rounded,
                                  size: 15,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  "143",
                                  style: GoogleFonts.roboto(
                                      fontSize: 15.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 10)
                            ]),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.15), blurRadius: 20)
                  ]),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                              height: 100.h,
                              width: 290.w,
                              child: ListView.builder(
                                  controller: _premiumScrollController,
                                  itemCount: _superPremiumChatList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    SuperPremiumChat chat =
                                        _superPremiumChatList[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        radius: 25.r,
                                        backgroundImage:
                                            AssetImage(chat.imageUrl),
                                      ),
                                      title: Text(
                                        chat.userName,
                                        style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      subtitle: Text(
                                        chat.chat,
                                        style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    );
                                  })),
                          SizedBox(
                            height: 200.h,
                            width: 290.w,
                            child: ListView.builder(
                                controller: _scrollController,
                                itemCount: _chatList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  dynamic chat = _chatList[index];
                                  if (chat.runtimeType == LiveChat) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        radius: 25.r,
                                        backgroundImage:
                                            AssetImage(chat.imageUrl),
                                      ),
                                      title: Text(
                                        chat.userName,
                                        style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      subtitle: Text(
                                        chat.chat,
                                        style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    );
                                  } else if ((chat.runtimeType ==
                                          PremiumChat) &&
                                      !(chat.isSticker)) {
                                    return Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFF55ACEE),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 25.r,
                                          backgroundImage:
                                              AssetImage(chat.imageUrl),
                                        ),
                                        title: Text(
                                          chat.userName,
                                          style: GoogleFonts.roboto(
                                              fontSize: 15.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        subtitle: Text(
                                          chat.chat,
                                          style: GoogleFonts.roboto(
                                              fontSize: 15.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    );
                                  } else if ((chat.runtimeType ==
                                          PremiumChat) &&
                                      (chat.isSticker)) {
                                    return Padding(
                                      padding: EdgeInsets.only(left: 15.w),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 25.r,
                                              backgroundImage:
                                                  AssetImage(chat.imageUrl),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  chat.userName,
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 15.sp,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Image.asset(chat.stickerPath,
                                                    height: 100, width: 100)
                                              ],
                                            ),
                                          ]),
                                    );
                                  }
                                }),
                          ),
                          Container(
                            height: 40.h,
                            width: 290.w,
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.r),
                                border: Border.all(color: Colors.white)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextField(
                                    maxLengthEnforcement:
                                        MaxLengthEnforcement.none,
                                    controller: _textEditingController,
                                    onSubmitted: (val) {
                                      addText();
                                    },
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        hintText: 'Type a Message',
                                        hintStyle: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            color: const Color(0xFFB6B7B8),
                                            fontWeight: FontWeight.bold),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0)),
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
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isLiked = !isLiked;
                                });
                              },
                              icon: Icon(
                                  isLiked
                                      ? CupertinoIcons.heart_fill
                                      : CupertinoIcons.heart,
                                  color: Colors.white,
                                  size: 40.h)),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (BuildContext context) {
                                    return SuperChat(
                                        addBasicPremiumChat:
                                            addBasicPremiumChat,
                                        addSuperPremiumChat:
                                            addSuperPremiumChat);
                                  });
                            },
                            child: Image.asset(
                              "assets/icons/superChat.png",
                              height: 50.h,
                              width: 50.h,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class SuperChat extends StatefulWidget {
  final void Function(PremiumChat) addBasicPremiumChat;
  final void Function(SuperPremiumChat) addSuperPremiumChat;
  const SuperChat(
      {Key? key,
      required this.addBasicPremiumChat,
      required this.addSuperPremiumChat})
      : super(key: key);

  @override
  State<SuperChat> createState() => _SuperChatState();
}

class _SuperChatState extends State<SuperChat> {
  final TextEditingController _inputController = TextEditingController();
  final PageController _controller = PageController();
  double _sliderValue = 0;
  String stickerPath = '';

  //This is for the stickers
  bool isSelected1 = false;
  bool isSelected2 = false;
  bool isSelected3 = false;
  bool isSelected4 = false;

  //For the 10 Dollar Super Chat
  void add10Chat(String chat) {
    widget.addBasicPremiumChat(PremiumChat(
      userName: "iamaswin",
      imageUrl: "assets/images/profile1.png",
      chat: chat,
      isPremium: true,
      isSticker: false,
      stickerPath: '',
    ));
  }

  //For the 20 Dollar Super Chat
  void add20Chat() {
    widget.addBasicPremiumChat(PremiumChat(
        userName: 'iamaswim',
        imageUrl: 'assets/images/profile1.png',
        chat: '',
        isPremium: true,
        isSticker: true,
        stickerPath: stickerPath));
  }

  //For other Super Chats
  void addOtherChats(Duration duration, String chat) {
    widget.addSuperPremiumChat(SuperPremiumChat(
        userName: 'iamaswim',
        imageUrl: 'assets/images/profile1.png',
        chat: chat,
        isPremium: true,
        isSticker: true,
        stickerPath: '',
        duration: duration));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F1F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Send a Super Chat?",
                style: GoogleFonts.roboto(
                  fontSize: 20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, size: 24, color: Colors.white),
              ),
            ],
          ),
          const Divider(color: Colors.white),
          SizedBox(height: 5.h),
          SizedBox(
            height: 204.h,
            child: PageView(
              onPageChanged: (_) {
                setState(() {
                  _sliderValue = _ * 25;
                });
              },
              controller: _controller,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 360.w,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.push_pin_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "Just highlights your chat in the live chat\nsection",
                            style: GoogleFonts.roboto(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF55ACEE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 10,
                                backgroundImage:
                                    AssetImage("assets/images/profile1.png"),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "@iamaswin",
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "\$10",
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white),
                          TextField(
                            controller: _inputController,
                            decoration: InputDecoration(
                              hintText: "Enter your chat...",
                              hintStyle: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                color: Color.fromRGBO(48, 48, 48, 0.61),
                                fontWeight: FontWeight.w400,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      "\$10",
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 360.w,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.push_pin_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "Send sticker along the live chat.",
                            style: GoogleFonts.roboto(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SizedBox(
                      height: 76.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSelected1 = true;
                                isSelected2 = false;
                                isSelected3 = false;
                                isSelected4 = false;
                                stickerPath = "assets/images/sticker_1.png";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected1
                                    ? const Color(0xFF1EA7D7).withOpacity(0.57)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Image.asset(
                                "assets/images/sticker_1.png",
                                height: 74.h,
                                width: 74.h,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSelected1 = false;
                                isSelected2 = true;
                                isSelected3 = false;
                                isSelected4 = false;
                                stickerPath = "assets/images/sticker_2.png";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected2
                                    ? const Color(0xFF1EA7D7).withOpacity(0.57)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Image.asset(
                                "assets/images/sticker_2.png",
                                height: 74.h,
                                width: 74.h,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSelected1 = false;
                                isSelected2 = false;
                                isSelected3 = true;
                                isSelected4 = false;
                                stickerPath = "assets/images/sticker_3.png";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected3
                                    ? const Color(0xFF1EA7D7).withOpacity(0.57)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Image.asset(
                                "assets/images/sticker_3.png",
                                height: 74.h,
                                width: 74.h,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSelected1 = false;
                                isSelected2 = false;
                                isSelected3 = false;
                                isSelected4 = true;
                                stickerPath = "assets/images/sticker_4.png";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected4
                                    ? const Color(0xFF1EA7D7).withOpacity(0.57)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Image.asset(
                                "assets/images/sticker_4.png",
                                height: 74.h,
                                width: 74.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      "\$20",
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 360.w,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.push_pin_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "Highlights your chat on top of live chat \nuntil the creator replies",
                            style: GoogleFonts.roboto(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF55ACEE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 10,
                                backgroundImage:
                                    AssetImage("assets/images/profile1.png"),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "@iamaswin",
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "\$50",
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white),
                          TextField(
                            controller: _inputController,
                            decoration: InputDecoration(
                              hintText: "Enter your chat...",
                              hintStyle: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                color: Color.fromRGBO(48, 48, 48, 0.61),
                                fontWeight: FontWeight.w400,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      "\$50",
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 360.w,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.push_pin_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "Highlights your chat on top of live chat \neven after the creator replies and \nstays there for 10 mins",
                            style: GoogleFonts.roboto(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF55ACEE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 10,
                                backgroundImage:
                                    AssetImage("assets/images/profile1.png"),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "@iamaswin",
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "\$100",
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white),
                          TextField(
                            controller: _inputController,
                            decoration: InputDecoration(
                              hintText: "Enter your chat...",
                              hintStyle: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                color: Color.fromRGBO(48, 48, 48, 0.61),
                                fontWeight: FontWeight.w400,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      "\$100",
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 360.w,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.push_pin_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "Highlights your chat on top of live chat \neven after the creator replies \nand stays there for 1 hour",
                            style: GoogleFonts.roboto(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF55ACEE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 11.w, vertical: 7.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 10,
                                backgroundImage:
                                    AssetImage("assets/images/profile1.png"),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "@iamaswin",
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "\$250",
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white),
                          TextField(
                            controller: _inputController,
                            decoration: InputDecoration(
                              hintText: "Enter your chat...",
                              hintStyle: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                color: Color.fromRGBO(48, 48, 48, 0.61),
                                fontWeight: FontWeight.w400,
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      "\$250",
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Slider(
            value: _sliderValue,
            onChanged: (_) {
              _controller.animateToPage(_ ~/ 25,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
              setState(() {
                _sliderValue = _;
              });
            },
            max: 100,
            divisions: 4,
          ),
          SizedBox(
            height: 15.h,
          ),
          ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: ElevatedButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(364.w, 33.h)),
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF001AFF))),
                  onPressed: () {
                    if (_sliderValue / 25 == 0) {
                      add10Chat(_inputController.text);
                      _inputController.text = '';
                    } else if (_sliderValue ~/ 25 == 1) {
                      add20Chat();
                    } else if (_sliderValue ~/ 25 == 2) {
                      addOtherChats(
                          const Duration(minutes: 1), _inputController.text);
                    } else if (_sliderValue ~/ 25 == 3) {
                      addOtherChats(
                          const Duration(minutes: 10), _inputController.text);
                    } else if (_sliderValue ~/ 25 == 4) {
                      addOtherChats(
                          const Duration(hours: 1), _inputController.text);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Buy and Send",
                    style: GoogleFonts.roboto(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  )))
        ],
      ),
    );
  }
}
