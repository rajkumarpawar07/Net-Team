import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../main.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _inputController = TextEditingController();
  late String id;
  List<User> _availableUser = [];
  List<User> _userList = [];

  void searchUsers(String query) {
    setState(() {
      _userList = _availableUser.where((user) {
        return user.userName.toLowerCase().contains(query.toLowerCase()) ||
            user.userId.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  // void getRandomUsers() {
  //   List<User> _randomUsers = [];
  //   // Random random = Random();
  //   // while (_randomUsers.length < 5) {
  //   //   int randomIndex = random.nextInt(_availableUser.length);
  //   //   User element = _availableUser[randomIndex];
  //   //   if (!_randomUsers.contains(element)) {
  //   //     _randomUsers.add(element);
  //   //   }
  //   // }
  //   setState(() {
  //     _userList = _randomUsers;
  //   });
  // }

  Future<void> getAllUsers() async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/getAllUsers";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String,dynamic>{
            "_id": id,
          })
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          data.forEach((user) {
            _availableUser.add(
              User(
                  objectId: user["_id"],
                  userId: user["fancyId"],
                  userName: user["name"],
                  imagePath: user["profilePic"] != "" ? '${dotenv.env['BACKEND_URL']}/${user["profilePic"]}' : "assets/images/avatar.jpg",
                  isLive: user["live"],
                  isFollowing: user["following"]
              )
            );
          });
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
    id = Provider.of<MyDataContainer>(context,listen: false).id;
    getAllUsers();
    super.initState();
  }

  _getImageProvider(User user) {
    return Uri.parse(user.imagePath).isAbsolute
        ? NetworkImage(user.imagePath)
        : AssetImage(user.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0B1F),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 48.h,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TextField(
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                          controller: _inputController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search",
                            contentPadding: EdgeInsets.all(10),
                            fillColor: const Color(0xFF343750),
                            filled: true,
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          onChanged: (_) {
                            searchUsers(_);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Expanded(
                child: ListView.builder(
                  itemCount: _userList.length,
                  itemBuilder: (BuildContext context, int index) {
                    User user = _userList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/userprofile', arguments: user);
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(bottom: 10),
                        leading: user.isLive
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 5,
                                    color: const Color(0xFF1EA7D7),
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 27,
                                  backgroundImage: _getImageProvider(user),
                                ),
                              )
                            : CircleAvatar(
                                radius: 33,
                                backgroundImage: _getImageProvider(user),
                              ),
                        title: Text(
                          user.userId,
                          style: GoogleFonts.poppins(
                            fontSize: 17.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          user.userName,
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class User {
  String objectId;
  String userId; //id refers to the user id. For Ex, @iamaswin
  String userName; //userName refers to full name of the user. For Ex, Aswin Raaj
  String imagePath; //imagePath refers to the url of the network image
  bool isLive; //isLive should be true, if the user is in live
  bool isFollowing;
  User(
      {required this.objectId,
        required this.userId,
      required this.userName,
      required this.imagePath,
      required this.isLive,
      required this.isFollowing});
}
