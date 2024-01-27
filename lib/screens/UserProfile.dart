import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../main.dart';
import 'Chat.dart';
import 'Followers-FollowinfDetails.dart';
import 'Search.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xFF0E0B1F),
        leading: IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
            size: 20.h,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/search');
          },
        ),
        automaticallyImplyLeading: false,
        title: Text(
          user.userName,
          style: GoogleFonts.roboto(
              fontSize: 17.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Body(
        user: user,
      ),
      backgroundColor: const Color(0xFF0E0B1F),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        color: Color(0xFF0E0B1F),
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
                  //Navigate to Home
                  Navigator.pushReplacementNamed(context, "/");
                },
              ),
              GestureDetector(
                child: SizedBox(
                    height: 40.h,
                    child: Icon(Icons.videocam_rounded,
                        size: 30.h, color: const Color(0xFFFFFFFF))),
                onTap: () {
                  //Navigate to Video Call
                  Navigator.pushReplacementNamed(context, "/videoset");
                },
              ),
              GestureDetector(
                child: SizedBox(
                    height: 40.h,
                    child: Icon(Icons.add_circle_rounded,
                        size: 30.h, color: const Color(0xFFFFFFFF))),
                onTap: () {
                  //Navigate to Add tiktok
                  Navigator.pushReplacementNamed(context, "/create");
                },
              ),
              GestureDetector(
                child: SizedBox(
                    height: 40.h,
                    child: Icon(Icons.chat_bubble,
                        size: 30.h, color: const Color(0xFFFFFFFF))),
                onTap: () {
                  //Navigate to chat
                  Navigator.pushReplacementNamed(context, "/chatlist");
                },
              ),
              GestureDetector(
                child: SizedBox(
                    height: 40.h,
                    child: Icon(Icons.account_circle,
                        size: 30.h, color: const Color(0xFF1EA7D7))),
                onTap: () {
                  //Navigate to Account section
                  Navigator.pushReplacementNamed(context, '/aboutyou');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  PageController pageController = PageController(initialPage: 0);
  int pageIndex = 0;
  String? baseUrl = dotenv.env['BACKEND_URL'];
  List<dynamic> posts = [];
  List<dynamic> saved = [];
  List<dynamic> followers = [];
  List<dynamic> following = [];
  IO.Socket socket = IO.io(dotenv.env['BACKEND_URL'], <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  Future<void> getDetails() async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/getPostsAndSaved";

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "userId": widget.user.objectId,
            "reqId": Provider.of<MyDataContainer>(context, listen: false).id,
          }));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          posts.addAll(data["postsInfo"]);
          saved.addAll(data["savedInfo"]);
          followers.addAll(data["followersInfo"]);
          following.addAll(data["followingInfo"]);
        });
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socket.connect();
    getDetails();
  }

  Future<void> changeFollow() async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/follow";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "_id": widget.user.objectId,
            "reqId": Provider.of<MyDataContainer>(context, listen: false).id,
            "followStatus": widget.user.isFollowing
          }));

      if (response.statusCode == 200) {
        setState(() {
          widget.user.isFollowing = !widget.user.isFollowing;
        });
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

  @override
  void dispose() {
    // TODO: implement dispose
    socket.dispose();
    super.dispose();
  }

  bool chatOpened = false;
  void handleChatClosed(bool isOpened) {
    // Handle the chat state here
    if (!isOpened) {
      chatOpened = false;
    }
  }

  _getImageProvider() {
    return Uri.parse(widget.user.imagePath).isAbsolute
        ? NetworkImage(widget.user.imagePath)
        : AssetImage(widget.user.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.user.isLive) {
                      Navigator.pushNamed(context, '/viewerslive');
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: (widget.user.isLive)
                            ? Border.all(
                                width: 5.0, color: const Color(0xFF1EA7D7))
                            : Border.all()),
                    child: CircleAvatar(
                      radius: 48.r,
                      backgroundImage: _getImageProvider(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  widget.user.userId,
                  style: GoogleFonts.roboto(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FollowersFollowing(
                                    fancyId: widget.user.userId,
                                    followers: followers,
                                    following: following)));
                      },
                      child: Column(
                        children: [
                          Text(
                            following.length.toString(),
                            style: GoogleFonts.roboto(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "Following",
                            style: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FollowersFollowing(
                                    fancyId: widget.user.userId,
                                    followers: followers,
                                    following: following)));
                      },
                      child: Column(
                        children: [
                          Text(
                            followers.length.toString(),
                            style: GoogleFonts.roboto(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "Followers",
                            style: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Column(
                      children: [
                        Text(
                          posts.length.toString(),
                          style: GoogleFonts.roboto(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          "Posts",
                          style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: (widget.user.isFollowing)
                          ? BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.r)),
                              border: Border.all(color: Colors.white, width: 1))
                          : BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.r)),
                            ),
                      height: 36.h,
                      width: 125.w,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0.0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Text(
                          widget.user.isFollowing ? "Following" : "Follow",
                          style: (widget.user.isFollowing)
                              ? GoogleFonts.poppins(color: Colors.white)
                              : GoogleFonts.poppins(color: Colors.black),
                        ),
                        onPressed: () {
                          changeFollow();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.r)),
                          border: Border.all(color: Colors.white, width: 1)),
                      height: 36.h,
                      width: 125.w,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0.0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Text("Message"),
                        onPressed: () {
                          //Navigate to chat screen
                          chatOpened = true;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Chat(
                                        socket: socket,
                                        handleChatClosed: handleChatClosed,
                                        name: widget.user.userName,
                                        userID: widget.user.objectId,
                                      )));
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Container(
            height: 40.h,
            decoration: const BoxDecoration(
                border: Border.symmetric(
                    horizontal:
                        BorderSide(color: Color(0xFFD0D1D3), width: 1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  (pageIndex == 0)
                      ? "assets/icons/posts_white.png"
                      : "assets/icons/posts_grey.png",
                  height: 15.h,
                  width: 15.h,
                ),
                Image.asset(
                  (pageIndex == 1)
                      ? "assets/icons/private_white.png"
                      : "assets/icons/private_grey.png",
                  height: 20.h,
                  width: 20.h,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.h),
            width: double.maxFinite,
            height: double.maxFinite,
            child: PageView(
                onPageChanged: (i) {
                  setState(() {
                    pageIndex = i;
                  });
                },
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      scrollDirection: Axis.vertical,
                      children: List.generate(posts.length, (index) {
                        return AspectRatio(
                          aspectRatio: 5 / 3,
                          child: Container(
                            color: Colors.grey,
                            child: Center(
                              child: CachedNetworkImage(
                                imageUrl:
                                    '$baseUrl/${posts[index]["thumbnailUrl"]}', // Replace with the actual image URL
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(), // Optional loading placeholder
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error), // Optional error widget
                                fit: BoxFit.cover, // Adjust the image fit
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      shrinkWrap: true,
                      children: List.generate(saved.length, (index) {
                        return Container(
                          color: Colors.grey,
                          child: Center(
                            child: CachedNetworkImage(
                              imageUrl:
                                  '$baseUrl/${saved[index]["thumbnailUrl"]}', // Replace with the actual image URL
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(), // Optional loading placeholder
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error), // Optional error widget
                              fit: BoxFit.cover, // Adjust the image fit
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ]),
          ),
        ],
      ),
    ));
  }
}
