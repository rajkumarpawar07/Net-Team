import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0E0B1F),
          elevation: 0.0,
        ),
        backgroundColor: const Color(0xFF0E0B1F),
        body: Body(),
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
                    Navigator.pushNamed(context, "/");
                  },
                ),
                GestureDetector(
                  child: SizedBox(
                      height: 40.h,
                      child: Icon(Icons.videocam_rounded,
                          size: 30.h, color: const Color(0xFFFFFFFF))),
                  onTap: () {
                    //Navigate to Video Call
                    Navigator.pushNamed(context, "/videoset");
                  },
                ),
                GestureDetector(
                  child: SizedBox(
                      height: 40.h,
                      child: Icon(Icons.add_circle_rounded,
                          size: 30.h, color: const Color(0xFFFFFFFF))),
                  onTap: () {
                    //Navigate to Add tiktok
                    Navigator.pushNamed(context, "/video15");
                  },
                ),
                GestureDetector(
                  child: SizedBox(
                      height: 40.h,
                      child: Icon(Icons.chat_bubble,
                          size: 30.h, color: const Color(0xFFFFFFFF))),
                  onTap: () {
                    //Navigate to chat
                    Navigator.pushNamed(context, "/chatlist");
                  },
                ),
                GestureDetector(
                  child: SizedBox(
                      height: 40.h,
                      child: Icon(Icons.account_circle,
                          size: 30.h, color: const Color(0xFF1EA7D7))),
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

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //Initial profile pic. Get from the server
  late String id, name, userID, email, socialURL;
  String imagePath = "assets/images/avatar.jpg";
  late List<String> interests;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = Provider.of<MyDataContainer>(context, listen: false).id;
    name = Provider.of<MyDataContainer>(context, listen: false).name;
    userID = Provider.of<MyDataContainer>(context, listen: false).userId;
    email = Provider.of<MyDataContainer>(context, listen: false).userEmail;
    socialURL = Provider.of<MyDataContainer>(context, listen: false).socialUrl;
  }

  Future<void> updateName(String newName) async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/updateName";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "_id": id,
            "name": newName,
          }));

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

  //For Changing Name
  void changeName() async {
    String? enteredName = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();
        nameController.text = name;
        return AlertDialog(
          backgroundColor: const Color(0xFF0E0B1F),
          title: Text('Change Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
                hintText: 'Enter new name',
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54))),
          ),
          actions: [
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(nameController.text);
                Provider.of<MyDataContainer>(context, listen: false).name =
                    nameController.text;
                updateName(nameController.text);
              },
            ),
          ],
        );
      },
    );

    if (enteredName != null && enteredName.isNotEmpty) {
      setState(() {
        name = enteredName;
      });
    }
  }

  Future<void> updateFancyId(String newFancyId) async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/updateFancyId";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "_id": id,
            "fancyId": newFancyId,
          }));

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

  //For Changing user ID
  void changeUserID() async {
    String? enteredUserID = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController userIDController = TextEditingController();
        userIDController.text = userID;

        return AlertDialog(
          backgroundColor: const Color(0xFF0E0B1F),
          title: Text('Change Name'),
          content: TextField(
            controller: userIDController,
            decoration: const InputDecoration(
                hintText: 'Enter new User ID',
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54))),
          ),
          actions: [
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(userIDController.text);
                Provider.of<MyDataContainer>(context, listen: false).userId =
                    userIDController.text;
                updateFancyId(userIDController.text);
              },
            ),
          ],
        );
      },
    );

    if (enteredUserID != null && enteredUserID.isNotEmpty) {
      setState(() {
        userID = enteredUserID;
      });
    }
  }

  Future<void> updateEmail(String newEmail) async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/updateEmail";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "_id": id,
            "userId": newEmail,
          }));

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

  //For Changing Email
  void changeEmail() async {
    String? enteredEmailID = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController userIDController = TextEditingController();
        userIDController.text = email;

        return AlertDialog(
          backgroundColor: const Color(0xFF0E0B1F),
          title: Text('Change Email'),
          content: TextField(
            controller: userIDController,
            decoration: const InputDecoration(
                hintText: 'Enter new email ID',
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54))),
          ),
          actions: [
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(userIDController.text);
                Provider.of<MyDataContainer>(context, listen: false).userEmail =
                    userIDController.text;
                updateEmail(userIDController.text);
              },
            ),
          ],
        );
      },
    );

    if (enteredEmailID != null && enteredEmailID.isNotEmpty) {
      setState(() {
        email = enteredEmailID;
      });
    }
  }

  Future<void> updateSocial(String newSocial) async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/updateSocial";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "_id": id,
            "socialId": newSocial,
          }));

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

  //For Changing Social URL
  void changeSocialURL() async {
    String? enteredSocialURL = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController userIDController = TextEditingController();
        userIDController.text = socialURL;

        return AlertDialog(
          backgroundColor: const Color(0xFF0E0B1F),
          title: Text('Change Social URL'),
          content: TextField(
            controller: userIDController,
            decoration: const InputDecoration(
                hintText: 'Enter new Social URL',
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54))),
          ),
          actions: [
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(userIDController.text);
                Provider.of<MyDataContainer>(context, listen: false).socialUrl =
                    userIDController.text;
                updateSocial(userIDController.text);
              },
            ),
          ],
        );
      },
    );

    if (enteredSocialURL != null && enteredSocialURL.isNotEmpty) {
      setState(() {
        socialURL = enteredSocialURL;
      });
    }
  }

  File _image = File("assets");

  Future<void> _getImage() async {
    //Changing Image
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    interests = Provider.of<MyDataContainer>(context).interests;
    return SafeArea(
        child: Container(
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF000000).withOpacity(0.25),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 74.r,
                        backgroundColor: Color(0xFF1EA7D7),
                        child: _image.path != "assets"
                            ? CircleAvatar(
                                radius: 71.r,
                                backgroundImage: FileImage(_image))
                            : CircleAvatar(
                                radius: 71.r,
                                backgroundImage: AssetImage(imagePath)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(103.w, 103.h, 0, 0),
                      child: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Color(0xFF1EA7D7),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt_rounded,
                              color: Color(0xFF0E0B1F)),
                          onPressed: _getImage,
                        ),
                      ),
                    )
                  ]),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    name,
                    style: GoogleFonts.roboto(
                        fontSize: 20.sp,
                        color: const Color(0xFFFBFBFB),
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    userID,
                    style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        color: const Color(0xFF898989),
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 10.h,
              color: const Color.fromRGBO(255, 240, 240, 0.1),
            ),
            Container(
              padding: EdgeInsets.only(top: 15.h, left: 24.w, right: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "About",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.sp),
                      ),
                      Icon(
                        Icons.edit,
                        color: const Color(0xFF1EA7D7),
                        size: 25.h,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      changeName();
                    },
                    child: Container(
                      height: 40.h,
                      margin: EdgeInsets.only(bottom: 15.h),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: const Color(0xFFA1A1A1)))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Full Name",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            name,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.sp,
                                color: const Color(0xFFDDDDDD)),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      changeUserID();
                    },
                    child: Container(
                      height: 40.h,
                      margin: EdgeInsets.only(bottom: 15.h),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: const Color(0xFFA1A1A1)))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "User ID",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            userID,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.sp,
                                color: const Color(0xFFDDDDDD)),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      changeEmail();
                    },
                    child: Container(
                      height: 40.h,
                      margin: EdgeInsets.only(bottom: 15.h),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: const Color(0xFFA1A1A1)))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Email ID",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            email,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.sp,
                                color: const Color(0xFFDDDDDD)),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      changeSocialURL();
                    },
                    child: Container(
                      height: 40.h,
                      margin: EdgeInsets.only(bottom: 15.h),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: const Color(0xFFA1A1A1)))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Social URL",
                            style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            socialURL,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.sp,
                                color: const Color(0xFFDDDDDD)),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/interests");
                    },
                    child: Container(
                      height: 40.h,
                      margin: EdgeInsets.only(bottom: 15.h),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: const Color(0xFFA1A1A1)))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "Interests",
                              style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              interests.join(" - "),
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.sp,
                                  color: const Color(0xFFDDDDDD)),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Divider(
              thickness: 10.h,
              color: const Color.fromRGBO(255, 240, 240, 0.1),
            ),
            Container(
              padding: EdgeInsets.only(top: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 24.w),
                    child: Text(
                      "Go Premium",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.sp),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFF171523),
                        border: Border(
                            top: BorderSide(
                          color: Color(0xFF5F5D5D),
                        ))),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Silver",
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontSize: 18.sp),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "\$99",
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
                                          color: const Color(0xFFAEAEAE)),
                                    ),
                                    Text(
                                      "/month",
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                          color: const Color(0xFFAEAEAE)),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 25.h,
                              width: 70.w,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color(0xFF480BF5))),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, "/pricingplans",
                                        arguments: 0);
                                  },
                                  child: Text(
                                    "View",
                                    style: GoogleFonts.roboto(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8.h,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "Feature 1",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.sp,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8.h,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "Feature 2",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.sp,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8.h,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "Feature 3",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.sp,
                                  color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFF171523),
                        border: Border(
                            top: BorderSide(
                          color: Color(0xFF5F5D5D),
                        ))),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Gold",
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontSize: 18.sp),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "\$149",
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
                                          color: const Color(0xFFAEAEAE)),
                                    ),
                                    Text(
                                      "/month",
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                          color: const Color(0xFFAEAEAE)),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 25.h,
                              width: 70.w,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color(0xFF480BF5))),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, "/pricingplans",
                                        arguments: 1);
                                  },
                                  child: Text(
                                    "View",
                                    style: GoogleFonts.roboto(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8.h,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "Feature 1",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.sp,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8.h,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "Feature 2",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.sp,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8.h,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "Feature 3",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.sp,
                                  color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFF171523),
                        border: Border(
                            top: BorderSide(
                              color: Color(0xFF5F5D5D),
                            ),
                            bottom: BorderSide(color: Color(0xFF5F5D5D)))),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Platinum",
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontSize: 18.sp),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "\$199",
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
                                          color: const Color(0xFFAEAEAE)),
                                    ),
                                    Text(
                                      "/month",
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                          color: const Color(0xFFAEAEAE)),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 25.h,
                              width: 70.w,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color(0xFF480BF5))),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, "/pricingplans",
                                        arguments: 2);
                                  },
                                  child: Text(
                                    "View",
                                    style: GoogleFonts.roboto(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8.h,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "Feature 1",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.sp,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8.h,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "Feature 2",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.sp,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8.h,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "Feature 3",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.sp,
                                  color: Colors.white),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
