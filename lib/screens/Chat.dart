import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import './Search.dart';

import '../main.dart';

class Chat extends StatelessWidget {
  Chat(
      {Key? key,
      required this.socket,
      required this.handleChatClosed,
      required this.name,
      required this.userID})
      : super(key: key);
  IO.Socket socket;
  final Function(bool isOpened) handleChatClosed;
  final String name;
  final String userID;
  late String id;

  Future<User> getUserDetail() async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/getUserProfile";
    // String apiUrl = "http://192.168.1.5:8080/getUserProfile";
    late User user;
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "_id": userID,
            "reqId": id,
          }));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        user = User(
            objectId: data["_id"],
            userId: data["fancyId"],
            userName: data["name"],
            imagePath: "assets/images/profile6.png",
            isLive: data["live"],
            isFollowing: data["following"]);
        return user;
      } else if (response.statusCode == 404) {
        // Handle the error accordingly
      } else {
        // Other error occurred
        // Handle the error accordingly
      }
    } catch (error) {
      // Error occurred during the API call
      // Handle the error accordingly
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    id = Provider.of<MyDataContainer>(context, listen: false).id;
    return Scaffold(
      backgroundColor: const Color(0xFF0E0B1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A172E),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button press here
            socket.emit('close-chat');
            handleChatClosed(false);
            Navigator.pop(context);
          },
        ),
        title: Text(
          name,
          style: GoogleFonts.nunito(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white),
        ),
        bottom: PreferredSize(
            preferredSize: Size(double.infinity, 50.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.phone_iphone_rounded,
                          size: 20.h,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          //Activate the request
                          socket.emit('ask-exchange-numbers');
                        },
                      ),
                      Text(
                        "Exchange Numbers",
                        style: GoogleFonts.roboto(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //Navigate to profile
                      getUserDetail().then((user) {
                        Navigator.pushNamed(context, '/userprofile',
                            arguments: user);
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF3A1398))),
                    child: Text(
                      "View Profile",
                      style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                size: 20.h,
              )),
        ],
      ),
      body: Body(
          socket: socket, handleChatClosed: handleChatClosed, userID: userID),
    );
  }
}

class ChatMessage {
  int userID;
  String text;
  ChatMessage({required this.userID, required this.text});
}

class Body extends StatefulWidget {
  Body(
      {Key? key,
      required this.socket,
      required this.handleChatClosed,
      required this.userID})
      : super(key: key);
  IO.Socket socket;
  final Function(bool isOpened) handleChatClosed;
  final String userID;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late String id;
  final String user1Number = "+91 9239239230";
  final String user2Number = "+91 678678678";

  bool isRequestVisible = false;

  final List<ChatMessage> _chatList = <ChatMessage>[];

  TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> storeMessages() async {
    // String apiUrl = "${dotenv.env['BACKEND_URL']}/sendMessage";
    String apiUrl = "http://192.168.1.5:8080/sendMessage";

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "from": id,
            "to": widget.userID,
            "message": _textEditingController.text,
          }));

      if (response.statusCode == 200) {
        setState(() {
          _chatList
              .add(ChatMessage(userID: 2, text: _textEditingController.text));
          widget.socket.emit("message", _textEditingController.text);
        });
        _textEditingController.text = '';
        FocusScope.of(context).unfocus();
        _scrollToBottom();
      } else if (response.statusCode == 404) {
        // Handle the error accordingly
      } else {
        // Other error occurred
        // Handle the error accordingly
      }
    } catch (error) {
      // Error occurred during the API call
      // Handle the error accordingly
    }
  }

  void addText() {
    if (_textEditingController.text != '') {
      storeMessages();
    }
  }

  Future<List<dynamic>> getMessages() async {
    // String apiUrl = "${dotenv.env['BACKEND_URL']}/retriveMessage";
    String apiUrl = "http://192.168.1.5:8080/retriveMessage";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "from": id,
            "to": widget.userID,
          }));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data;
      } else if (response.statusCode == 404) {
        // Handle the error accordingly
      } else {
        // Other error occurred
        // Handle the error accordingly
      }
    } catch (error) {
      // Error occurred during the API call
      // Handle the error accordingly
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    id = Provider.of<MyDataContainer>(context, listen: false).id;
    getMessages().then((chatHistory) {
      setState(() {
        chatHistory.forEach((message) => _chatList.add(ChatMessage(
            userID: (message["from"] == id) ? 2 : 1,
            text: message["message"])));
      });
    });
    widget.socket.on("message", (data) {
      setState(() {
        _chatList.add(ChatMessage(userID: 1, text: data));
      });
    });
    widget.socket.on("ask-exchange-numbers", (_) {
      setState(() {
        isRequestVisible = true;
      });
    });
    widget.socket.on("reply-exchange-numbers", (_) {
      setState(() {
        List<ChatMessage> _contactAdd = <ChatMessage>[
          ChatMessage(userID: 2, text: "Aswin Raaj number : ${user1Number}")
        ];
        _chatList.addAll(_contactAdd);
      });
      widget.socket.emit("message", "Aswin Raaj number : ${user1Number}");
    });
    widget.socket.on("close-chat", (_) {
      widget.handleChatClosed(false);
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (mounted) {
      widget.socket.off("message");
      widget.socket.off("ask-exchange-numbers");
      widget.socket.off("reply-exchange-numbers");
      widget.socket.off("close-chat");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 10.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isRequestVisible
                ? Center(
                    child: Container(
                      height: 90.h,
                      width: 245.w,
                      margin: EdgeInsets.only(top: 15.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: const Color(0xFF262228),
                      ),
                      padding: EdgeInsets.all(9.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Aswin Raaj has requested for phone number exchange ?",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _chatList.add(ChatMessage(
                                        userID: 2,
                                        text:
                                            "Sorry, I can't share my number"));
                                  });
                                  widget.socket.emit("message",
                                      "Sorry, I can't share my number");
                                  isRequestVisible = !isRequestVisible;
                                },
                                child: Container(
                                    height: 25.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFE91C43),
                                        borderRadius:
                                            BorderRadius.circular(5.r)),
                                    child: Center(
                                      child: Text(
                                        "Deny",
                                        style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    List<ChatMessage> _contactAdd =
                                        <ChatMessage>[
                                      ChatMessage(
                                          userID: 2,
                                          text:
                                              "Person X number : ${user2Number}"),
                                    ];
                                    _chatList.addAll(_contactAdd);
                                  });
                                  widget.socket.emit("message",
                                      "Person X number : ${user2Number}");
                                  widget.socket.emit("reply-exchange-numbers");
                                  isRequestVisible = !isRequestVisible;
                                },
                                child: Container(
                                    height: 25.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF2B8C52),
                                        borderRadius:
                                            BorderRadius.circular(5.r)),
                                    child: Center(
                                      child: Text(
                                        "Accept",
                                        style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    height: 0.h,
                  ),
            SizedBox(
              height: isRequestVisible ? 505.h : 610.h,
              child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: _chatList.length,
                  itemBuilder: (BuildContext context, int index) {
                    ChatMessage chatMessage = _chatList[index];
                    return Row(
                      mainAxisAlignment: (2 == chatMessage.userID)
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          //For Demonstration purpose of mocking that other person requested for Exchange number. Will be removed in the production
                          onTap: () {
                            setState(() {
                              isRequestVisible = !isRequestVisible;
                            });
                          },
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 270.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: (2 == chatMessage.userID)
                                  ? const Color(0xFF272A35)
                                  : const Color(0xFF1A172E),
                            ),
                            padding: EdgeInsets.all(10.h),
                            margin: EdgeInsets.fromLTRB(
                                0, (index == 0 ? 15.h : 7.5.h), 0, 7.5.h),
                            child: Text(
                              chatMessage.text,
                              style: GoogleFonts.roboto(
                                  fontSize: 13.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            Container(
              height: 50.h,
              width: 350.w,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                color: const Color(0xFF1A172E),
              ),
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
                            borderSide:
                                BorderSide(color: Color.fromRGBO(0, 0, 0, 0)),
                          ),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent))),
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
            )
          ],
        ),
      ),
    );
  }
}
