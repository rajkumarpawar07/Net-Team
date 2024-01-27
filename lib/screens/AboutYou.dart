import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'Followers-FollowinfDetails.dart';
import 'UploadVideoForm.dart';

class AboutYou extends StatefulWidget {
  const AboutYou({Key? key}) : super(key: key);

  @override
  State<AboutYou> createState() => _AboutYouState();
}

class _AboutYouState extends State<AboutYou> {
  /// part of video editor sdk
  static const String LICENSE_TOKEN =
      "Qk5CILx021FztBkHJbKfJy08lQgsTWwa/AZKEd//4+N2VtgatlBHJCW+tg4XGjh9DaLt2Uv8llIQtd/KABU6bNrEJbQNL0CynNilmfgS+c39BBi0b+31C42OU/7yk2TVFTiRTpGJKGLM94n5GTeBHCqCFW6v8nNvVCQnPDhhcRXNwJMZMh+h7eDKKgEFblBYOJd0+/L7ZzM6Ypz9XZEwiAKIWRppQGNRAHHXhvB1H/cEcBI8DxwsLzmFeM2CszEBQD4PRLastoZL2xu7jDdIdquwLPe91AQrTGScrdqIPzmPhT6DlLwJWGKwoBemoDCoDVsgPUbJs9EwW1bMeTV4t59YZ3Ofuq96rLAiKRSsuVftlADVp++80SYxiw1CJccQXvu2LORtoHbKZC6mYCjKt6vTxUWMTtpQBLLUJgqgy4B6r5TbzbPVdwiwvgLlHCW31tWyFrzu7MDIth4EUtghvqW2wtAVt/3mPeFNecwKdTbj+bC8Qn1WIrSPFs+/Xz6NO5Ptj+ROEY3ronMSbGHYurVkDYPmK39MRGjcdcaMDPPnr3UAhR+NVwgMtghko0V6eMW7ZGpDIOxocp01WZPG863QohiCyXYbYwLheq7g8omSP+G3+YTfre9RrgDv5uh2VZz6RmiOzD8qkHaK3fBUcw==";

  // static String? LICENSE_TOKEN = dotenv.env['BANUBA_LICENSE_TOKEN'];

  static const channelName = 'startActivity/VideoEditorChannel';

  static const methodInitVideoEditor = 'InitBanubaVideoEditor';
  static const methodStartVideoEditor = 'StartBanubaVideoEditor';
  static const methodStartVideoEditorPIP = 'StartBanubaVideoEditorPIP';
  static const methodStartVideoEditorTrimmer = 'StartBanubaVideoEditorTrimmer';
  static const methodDemoPlayExportedVideo = 'PlayExportedVideo';

  static const errMissingExportResult = 'ERR_MISSING_EXPORT_RESULT';
  static const errStartPIPMissingVideo = 'ERR_START_PIP_MISSING_VIDEO';
  static const errStartTrimmerMissingVideo = 'ERR_START_TRIMMER_MISSING_VIDEO';
  static const errExportPlayMissingVideo = 'ERR_EXPORT_PLAY_MISSING_VIDEO';

  static const errEditorNotInitializedCode = 'ERR_VIDEO_EDITOR_NOT_INITIALIZED';
  static const errEditorNotInitializedMessage =
      'Banuba Video Editor SDK is not initialized: license token is unknown or incorrect.\nPlease check your license token or contact Banuba';
  static const errEditorLicenseRevokedCode = 'ERR_VIDEO_EDITOR_LICENSE_REVOKED';
  static const errEditorLicenseRevokedMessage =
      'License is revoked or expired. Please contact Banuba https://www.banuba.com/faq/kb-tickets/new';

  static const argExportedVideoFile = 'exportedVideoFilePath';
  static const argExportedVideoCoverPreviewPath =
      'exportedVideoCoverPreviewPath';

  static const platform = MethodChannel(channelName);

  String _errorMessage = '';

  Future<void> _initVideoEditor() async {
    await platform.invokeMethod(methodInitVideoEditor, LICENSE_TOKEN);
  }

  Future<void> _startVideoEditorDefault() async {
    try {
      await _initVideoEditor();

      final result = await platform.invokeMethod(methodStartVideoEditor);

      _handleExportResult(result);
      print(result);
    } on PlatformException catch (e) {
      _handlePlatformException(e);
    }
  }

  void _handleExportResult(dynamic result) {
    debugPrint('Export result = $result');

    // You can use any kind of export result passed from platform.
    // Map is used for this sample to demonstrate playing exported video file.
    if (result is Map) {
      final exportedVideoFilePath = result[argExportedVideoFile];

      print(exportedVideoFilePath);

      // Use video cover preview to meet your requirements
      final exportedVideoCoverPreviewPath =
          result[argExportedVideoCoverPreviewPath];

      print("Edited video path $exportedVideoFilePath");

      /// pass this edited video to form screen
      Get.to(() => VideoUploadForm(
            videoFile: File(exportedVideoFilePath),
          ));
      // _showConfirmation(context, "Play exported video file?", () {
      //   platform.invokeMethod(
      //       methodDemoPlayExportedVideo, exportedVideoFilePath);
      // });
    }
  }

  // Handle exceptions thrown on Android, iOS platform while opening Video Editor SDK
  void _handlePlatformException(PlatformException exception) {
    debugPrint("Error: '${exception.message}'.");

    String errorMessage = '';
    switch (exception.code) {
      case errEditorLicenseRevokedCode:
        errorMessage = errEditorLicenseRevokedMessage;
        break;
      case errEditorNotInitializedCode:
        errorMessage = errEditorNotInitializedMessage;
        break;
      default:
        errorMessage = 'unknown error';
    }

    _errorMessage = errorMessage;
    setState(() {});
  }

  void _showConfirmation(
      BuildContext context, String message, VoidCallback block) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          MaterialButton(
            color: Colors.red,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: const EdgeInsets.all(12.0),
            splashColor: Colors.redAccent,
            onPressed: () => {Navigator.pop(context)},
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
          MaterialButton(
            color: Colors.green,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: const EdgeInsets.all(12.0),
            splashColor: Colors.greenAccent,
            onPressed: () {
              Navigator.pop(context);
              block.call();
            },
            child: const Text(
              'Ok',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = Provider.of<MyDataContainer>(context, listen: false).name;
    final dataContainer = Provider.of<MyDataContainer>(context, listen: false);
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
          name,
          style: GoogleFonts.roboto(
              fontSize: 17.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('Authorization', '');
                dataContainer.updateData("", "", "", "", "", "", []);
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 20.h,
              ))
        ],
      ),
      body: Body(),
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
                  _startVideoEditorDefault();
                  // Navigator.pushNamed(context, "/create");
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
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  PageController pageController = PageController(initialPage: 0);
  int pageIndex = 0;
  List<dynamic> posts = [];
  List<dynamic> saved = [];
  List<dynamic> followers = [];
  List<dynamic> following = [];
  late String id, userId, profilePic, email;
  String? baseUrl = dotenv.env['BACKEND_URL'];

  Future<void> getPostsAndSaved() async {
    print("AboutYou");
    print("userId ${id}");
    print("reqId ${id}");
    String apiUrl = "${dotenv.env['BACKEND_URL']}/getPostsAndSaved";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "userId": id,
            "reqId": id,
          }));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("data ${data}");

        setState(() {
          posts.addAll(data["postsInfo"]);
          print('posts ${posts}');
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
    id = Provider.of<MyDataContainer>(context, listen: false).id;
    email = Provider.of<MyDataContainer>(context, listen: false).userEmail;
    userId = Provider.of<MyDataContainer>(context, listen: false).userId;
    profilePic =
        Provider.of<MyDataContainer>(context, listen: false).profilePic;
    getPostsAndSaved();
  }

  _getImageProvider() {
    return profilePic != ""
        ? NetworkImage('${dotenv.env['BACKEND_URL']}/$profilePic')
        : const AssetImage("assets/images/avatar.jpg");
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
                CircleAvatar(
                  radius: 48.r,
                  backgroundImage: _getImageProvider(),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  '@$userId',
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
                                    fancyId: userId,
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
                                    fancyId: userId,
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.r)),
                          border: Border.all(color: Colors.white, width: 1)),
                      height: 36.h,
                      width: 150.w,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0.0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: Text("Edit Profile"),
                        onPressed: () {
                          Navigator.pushNamed(context, "/profile");
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
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
                            color: Colors.black,
                            child: Center(
                              child: CachedNetworkImage(
                                imageUrl: posts[index]["thumbnailUrl"]!,
                                // imageUrl:
                                //     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3uz34maCvLgFw9EOcKy71KuCMMAmMoOmjX3bW_oOpgajfhVuX8859XKKTbQ&s', // Replace with the actual image URL
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(), // Optional loading placeholder
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error), // Optional error widget
                                fit: BoxFit.fill, // Adjust the image fit
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
