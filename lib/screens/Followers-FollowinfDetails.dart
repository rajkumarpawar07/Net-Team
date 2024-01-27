import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../main.dart';

class FollowersFollowing extends StatefulWidget {
  const FollowersFollowing({super.key,required this.fancyId,required this.followers,required this.following});
  final String fancyId;
  final List<dynamic> followers;
  final List<dynamic> following;

  @override
  State<FollowersFollowing> createState() => _FollowersFollowingState();
}

class _FollowersFollowingState extends State<FollowersFollowing>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<UserInfo> _following = <UserInfo>[];
  final List<UserInfo> _followers = <UserInfo>[];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    widget.followers.forEach((follower) {
      _followers.add(UserInfo(
          objectId: follower["followerId"],
          userID: follower["followerName"],
          imagePath: follower["followerPic"] != "" ? '${dotenv.env["BACKEND_URL"]}/${follower["followerPic"]}' : "assets/images/avatar.jpg",
          isFollowed: follower["following"]
      ));
    });
    widget.following.forEach((following) {
      _following.add(UserInfo(
          objectId: following["followingId"],
          userID: following["followingName"],
          imagePath: following["followingPic"] != "" ? '${dotenv.env["BACKEND_URL"]}/${following["followingPic"]}' : "assets/images/avatar.jpg",
          isFollowed: following["following"]
      ));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> changeFollow(UserInfo follow) async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/follow";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String,dynamic>{
            "_id": follow.objectId,
            "reqId": Provider.of<MyDataContainer>(context,listen: false).id,
            "followStatus": follow.isFollowed
          })
      );

      if (response.statusCode == 200) {
        return;
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

  _getImageProvider(UserInfo user) {
    return Uri.parse(user.imagePath).isAbsolute
        ? NetworkImage(user.imagePath)
        : AssetImage(user.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0B1F),
      appBar: AppBar(
        title: Text(
          widget.fancyId,
          style: GoogleFonts.roboto(
              fontSize: 17.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF0E0B1F),
        bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: '${_following.length.toString()} Following',
              ),
              Tab(
                text: "${_followers.length.toString()} Followers",
              ),
            ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(5.h),
            child: ListView.builder(
                itemCount: _following.length,
                itemBuilder: (BuildContext context, int index) {
                  UserInfo _user = _following[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: _getImageProvider(_user),
                      radius: 22.5.r,
                    ),
                    title: Text(
                      _user.userID,
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: (_user.isFollowed) ?
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(EdgeInsets.zero),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF0E0B1F)),
                                fixedSize:
                                    MaterialStateProperty.all(Size(90.w, 23.h))),
                            onPressed: () {
                              changeFollow(_following[index]).then((_) {
                                setState(() {
                                  _following[index].isFollowed = !_following[index].isFollowed;
                                });
                              });
                            },
                            child: Text(
                              "Following",
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600),
                            )),
                      )
                     : ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF1EA7D7)),
                              fixedSize:
                                  MaterialStateProperty.all(Size(85.w, 23.h))),
                          onPressed: () {
                            changeFollow(_followers[index]).then((_) {
                              setState(() {
                                _followers[index].isFollowed = !_followers[index].isFollowed;
                              });
                            });
                          },
                          child: Text(
                            "Follow",
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                  );
                }),
          ),
          Container(
            padding: EdgeInsetsDirectional.all(5.h),
            child: ListView.builder(
                itemCount: _followers.length,
                itemBuilder: (BuildContext context, int index) {
                  UserInfo _user = _followers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: _getImageProvider(_user),
                      radius: 22.5.r,
                    ),
                    title: Text(
                      _user.userID,
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: (_user.isFollowed) ?
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(EdgeInsets.zero),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF0E0B1F)),
                                fixedSize:
                                    MaterialStateProperty.all(Size(90.w, 23.h))),
                            onPressed: () {
                              setState(() {
                                _followers[index].isFollowed =
                                    !_followers[index].isFollowed;
                              });
                            },
                            child: Text(
                              "Following",
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600),
                            )),
                      )
                     : ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF1EA7D7)),
                              fixedSize:
                                  MaterialStateProperty.all(Size(85.w, 23.h))),
                          onPressed: () {
                            setState(() {
                              _followers[index].isFollowed =
                                  !_followers[index].isFollowed;
                            });
                          },
                          child: Text(
                            "Follow",
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}

class UserInfo {
  String objectId;
  String userID;
  String imagePath;
  bool isFollowed;
  UserInfo(
      {required this.objectId,
        required this.userID,
      required this.imagePath,
      required this.isFollowed});
}
