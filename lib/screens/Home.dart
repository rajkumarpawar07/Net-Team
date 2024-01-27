import 'dart:convert';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../main.dart';
import 'UploadVideoForm.dart';

class ApiService {
  static String? baseUrl = dotenv.env['BACKEND_URL'];

  Future<List<dynamic>> fetchReels(String userId) async {
    try {
      print("fetching reels");
      print("userId ${userId}");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = await prefs.getString('Authorization');
      print("Token ${token}");
      final response = await http.get(
        Uri.parse('$baseUrl/reels'),
        headers: {
          'Content-Type': 'application/json',
          // "token": token!
        },
        // body: json.encode(<String, dynamic>{
        //   "email": userId,
        // })
      );
      final data = json.decode(response.body);
      print("reels data ${data}");
      if (response.statusCode == 200) {
        // print(response.body);
        return data;
      } else {
        throw Exception('Failed to fetch reels');
      }
    } catch (e) {
      print("error ${e}");
      return [];
    }
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class ScreenArguments {
  final bool isLiked;
  ScreenArguments({required this.isLiked});
}

class _HomeState extends State<Home> {
  final PageController _controller = PageController(viewportFraction: 1);
  bool isShared = false;
  late String reelId;
  late String id;

  final apiService = ApiService();
  List<dynamic> reels = [];
  Future<void> fetchReels() async {
    final fetchedReels = await apiService.fetchReels(id);
    setState(() {
      reels = fetchedReels;
    });
  }

  late ChewieController _chewierController;
  int _currentPlayingIndex = 0;

  @override
  void initState() {
    super.initState();
    id = Provider.of<MyDataContainer>(context, listen: false).userEmail;
    fetchReels();
    print(reels);
  }

  Future<void> savedButtonPressed(bool isSaved) async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/save";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "videoId": reelId,
            "userId": id,
            "savedStatus": isSaved,
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
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            child: Stack(
              children: [
                //We need swiper for every content
                Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    final reel = reels[index];
                    // reelId = reel["_id"];
                    return ContentScreen(reel: reel
                        // likedStatus: reel["likedStatus"],
                        // likeCount: reel["likesCount"],
                        // reelId: reel['_id'],
                        // src: reel['videoUrl'],
                        // author: reel['author'],
                        // description: reel['description'],
                        // likes: reel['likes'],
                        // comments: reel['comments']
                        );
                  },
                  itemCount: reels.length,
                  scrollDirection: Axis.vertical,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Net Team",
                        style: GoogleFonts.roboto(
                            fontSize: 25.sp,
                            color: const Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.camera_alt),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
                          size: 30.h, color: const Color(0xFF1EA7D7))),
                  onTap: () {
                    //Navigate to Home
                    // Navigator.pop(context);
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
                    // Navigator.pop(context);
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
                    // Navigator.pop(context);

                    _startVideoEditorDefault();

                    // Navigator.pushReplacementNamed(context, "/create");
                  },
                ),
                GestureDetector(
                  child: SizedBox(
                      height: 40.h,
                      child: Icon(Icons.chat_bubble,
                          size: 30.h, color: const Color(0xFFFFFFFF))),
                  onTap: () {
                    //Navigate to chat
                    // Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/chatlist");
                  },
                ),
                GestureDetector(
                  child: SizedBox(
                      height: 40.h,
                      child: Icon(Icons.account_circle,
                          size: 30.h, color: const Color(0xFFFFFFFF))),
                  onTap: () {
                    //Navigate to Account section
                    // Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/aboutyou");
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

/// content Screen
class ContentScreen extends StatefulWidget {
  // final String? src;
  // final String? author;
  // final String? description;
  // final List? likes;
  // final List? comments;
  // final String? reelId;
  // final bool? likedStatus;
  // final int? likeCount;
  final dynamic reel;
  const ContentScreen({
    Key? key,
    required this.reel,
    // this.src,
    // this.author,
    // this.description,
    // this.likes,
    // this.comments,
    // this.reelId,
    //   this.likedStatus,
    //   this.likeCount
  }) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.reel['videoUrl']!));
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: false,
      looping: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    // _chewieController!.dispose();
    if (_chewieController != null) {
      _chewieController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? GestureDetector(
                onDoubleTap: () {},
                child: Chewie(
                  controller: _chewieController!,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Loading...')
                ],
              ),
        if (_liked)
          Center(
            child: LikeIcon(),
          ),
        OptionsScreen(
          reel: widget.reel ?? "",
          // author: widget.reel['author'],
          // description: widget.reel['description'],
          // likes: widget.reel['likes'],
          // comments: widget.reel['comments'],
        ),
      ],
    );
  }
}

/// Liked Icon
class LikeIcon extends StatelessWidget {
  Future<int> tempFuture() async {
    return Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: tempFuture(),
        builder: (context, snapshot) =>
            snapshot.connectionState != ConnectionState.done
                ? Icon(Icons.favorite, size: 110)
                : SizedBox(),
      ),
    );
  }
}

/// Options Screen
class OptionsScreen extends StatefulWidget {
  // final String? author;
  // final String? description;
  // final List? likes;
  // final List? comments;
  final dynamic reel;
  const OptionsScreen({
    Key? key,
    this.reel,
    // this.author,
    // this.description,
    // this.likes,
    // this.comments
  }) : super(key: key);
  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  bool isLiked = false;
  bool _isFollowing = false;
  bool savedStatus = false;
  late String id;

  Future<void> likeButtonPressed(bool isLiked) async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/like";
    try {
      print("like button pressed");
      print("videoId : ${widget.reel['_id']}");
      print("userId : ${id}");
      print("likedstatus : ${isLiked}");
      print(widget.reel["likesCount"]);
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "videoId": widget.reel['_id'],
            "userId": id,
            "likedStatus": !isLiked,
          }));

      if (response.statusCode == 200) {
        print("video liked successfully");
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

  @override
  void initState() {
    super.initState();
    id = Provider.of<MyDataContainer>(context, listen: false).id;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 110),
                    Row(
                      children: [
                        CircleAvatar(
                          child: Icon(Icons.person, size: 18),
                          radius: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          widget.reel['author'] ?? "user",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.verified,
                          size: 15,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 6),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(" ${widget.reel['description']}"),
                    SizedBox(height: 10),
                    // Row(
                    //   children: [
                    //     Icon(
                    //       Icons.music_note,
                    //       size: 15,
                    //       color: Colors.white,
                    //     ),
                    //     Text('Original Audio - some music track--'),
                    //   ],
                    // ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      likeButtonPressed(!widget.reel["likedStatus"])
                          .then((_) => {
                                setState(() {
                                  if (widget.reel["likedStatus"]) {
                                    widget.reel["likedStatus"] = false;
                                    widget.reel["likesCount"] -= 1;
                                  } else {
                                    widget.reel["likedStatus"] = true;
                                    widget.reel["likesCount"] += 1;
                                  }
                                })
                              });
                    },
                    icon: Icon(
                      widget.reel["likedStatus"]
                          ? Icons.favorite
                          : Icons.favorite_border, // Change icon based on state
                      color: widget.reel["likedStatus"]
                          ? Colors.red
                          : Colors.white,
                      size: 30.h, // Change color based on state
                    ),
                  ),
                  // Text(widget.reel['likes'].length.toString()),
                  Text(widget.reel["likesCount"].toString()),
                  SizedBox(height: 15),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return CommentSection(reelId: widget.reel['_id']);
                          });
                    },
                    icon: Icon(
                      Icons.comment_rounded,
                      color: Colors.white,
                      size: 30.h,
                    ),
                  ),
                  Text(widget.reel['comments'].length.toString()),
                  SizedBox(height: 15),
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                savedStatus = !savedStatus;
                              });
                            },
                            icon: Icon(
                              savedStatus
                                  ? Icons.bookmark
                                  : Icons.bookmark_outline,
                              size: 30.h,
                              color: Colors.white,
                            )),
                        // Text(
                        //   "2",
                        //   style: GoogleFonts.roboto(
                        //       fontSize: 12.sp,
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.bold),
                        // )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Icon(Icons.more_vert, color: Colors.white),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

//Class for Comment
class Comment {
  String commentId;
  String imageUrl;
  String userName;
  String comment;
  int noOfLikes;
  bool isLiked;
  Comment(
      {required this.commentId,
      required this.imageUrl,
      required this.userName,
      required this.comment,
      this.noOfLikes = 0,
      this.isLiked = false});
}

/// comment section
class CommentSection extends StatefulWidget {
  const CommentSection({Key? key, required this.reelId}) : super(key: key);
  final String reelId;

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final List<Comment> _commentList = <Comment>[];
  late String id, name, profilePic, userId;

  TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> postComment() async {
    print("post comment");
    String apiUrl = "${dotenv.env['BACKEND_URL']}/postComment";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "videoId": widget.reelId,
            "author": id,
            "comment": _textEditingController.text
          }));

      if (response.statusCode == 200) {
        print("commented");
        final data = json.decode(response.body);
        setState(() {
          _commentList.add(Comment(
            commentId: data,
            imageUrl: profilePic != ""
                ? '${dotenv.env['BACKEND_URL']}/$profilePic'
                : "assets/images/avatar.jpg",
            userName: userId,
            comment: _textEditingController.text,
            noOfLikes: 0,
            isLiked: false,
          ));
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
      print("error ${error}");
      // Error occurred during the API call
      // Handle the error accordingly
    }
  }

  void addComment() {
    if (_textEditingController.text != '') {
      postComment();
    }
  }

  Future<void> getComments() async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/getComments";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "videoId": widget.reelId,
            "userId": id,
          }));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          data.forEach((comment) {
            _commentList.add(Comment(
              commentId: comment["_id"],
              imageUrl: comment["profilePic"] != ""
                  ? '${dotenv.env['BACKEND_URL']}/${comment["profilePic"]}'
                  : "assets/images/avatar.jpg",
              userName: comment["authorName"],
              comment: comment["comment"],
              noOfLikes: comment["likesCount"],
              isLiked: comment["likedStatus"],
            ));
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
    super.initState();
    id = Provider.of<MyDataContainer>(context, listen: false).id;
    name = Provider.of<MyDataContainer>(context, listen: false).name;
    userId = Provider.of<MyDataContainer>(context, listen: false).userId;
    profilePic =
        Provider.of<MyDataContainer>(context, listen: false).profilePic;
    getComments();
    print("profilePic ${profilePic}");
  }

  Future<void> likeComment(String commentId, bool isLiked) async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/likeComment";
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "videoId": widget.reelId,
            "commentId": commentId,
            "userId": id,
            "likedStatus": isLiked,
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

  _getImageProvider(Comment comment) {
    return Uri.parse(comment.imageUrl).isAbsolute
        ? NetworkImage(comment.imageUrl)
        : AssetImage(comment.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
          color: const Color(0xFF101010)),
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Comments',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _commentList.length,
              itemBuilder: ((BuildContext context, int index) {
                Comment _comment = _commentList[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: _getImageProvider(_comment),
                    radius: 20.r,
                  ),
                  title: Text("@${_comment.userName}"),
                  subtitle: Text(_comment.comment),
                  trailing: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          likeComment(_commentList[index].commentId,
                                  _commentList[index].isLiked)
                              .then((_) {
                            setState(() {
                              if (_commentList[index].isLiked) {
                                _commentList[index].noOfLikes--;
                              } else {
                                _commentList[index].noOfLikes++;
                              }
                              _commentList[index].isLiked =
                                  !_commentList[index].isLiked;
                            });
                          });
                        },
                        child: Icon(
                          _comment.isLiked
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: Colors.white,
                          size: 20.h,
                        ),
                      ),
                      Text("${_comment.noOfLikes}")
                    ],
                  ),
                );
              }),
            ),
          ),
          Container(
            height: 50.h,
            width: 350.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.h),
              borderRadius: BorderRadius.circular(25.r),
              color: const Color(0xFF101010),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    maxLengthEnforcement: MaxLengthEnforcement.none,
                    controller: _textEditingController,
                    onSubmitted: (val) {
                      addComment();
                    },
                    decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            color: const Color(0xFFB6B7B8),
                            fontWeight: FontWeight.bold),
                        border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, 0)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent))),
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
                      addComment();
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
    );
  }
}
