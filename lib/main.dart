import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_ve_sdk/audio_browser.dart';
import 'package:flutter_ve_sdk/screens/AboutYou.dart';
import 'package:flutter_ve_sdk/screens/Chatlist.dart';
import 'package:flutter_ve_sdk/screens/ForgotPassword.dart';
import 'package:flutter_ve_sdk/screens/Home.dart';
import 'package:flutter_ve_sdk/screens/Interests.dart';
import 'package:flutter_ve_sdk/screens/PricingPlans.dart';
import 'package:flutter_ve_sdk/screens/Profile.dart';
import 'package:flutter_ve_sdk/screens/Search.dart';
import 'package:flutter_ve_sdk/screens/UserProfile.dart';
import 'package:flutter_ve_sdk/screens/VideoSet.dart';
import 'package:flutter_ve_sdk/screens/ViewersLive.dart';
import 'package:flutter_ve_sdk/screens/login.dart';
import 'package:flutter_ve_sdk/screens/signup.dart';
import 'package:flutter_ve_sdk/screens/splashscreen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'screens/CreateVideoNew.dart';

class MyDataContainer extends ChangeNotifier {
  String id = "";
  String name = "";
  String profilePic = "";
  String userId = "";
  String userEmail = "";
  String socialUrl = "";
  List<String> interests = [];

  void updateData(
      String newId,
      String newName,
      String newProfilePic,
      String newUserId,
      String newUserEmail,
      String newSocialUrl,
      List<String> newInterests) {
    id = newId;
    name = newName;
    profilePic = newProfilePic;
    userId = newUserId;
    userEmail = newUserEmail;
    socialUrl = newSocialUrl;
    interests.addAll(newInterests);
    notifyListeners();
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final cameras = await availableCameras();
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyDataContainer(),
      child: MyApp(
        cameras: cameras,
      ),
    ),
  );
}

/// The entry point for Audio Browser implementation
@pragma('vm:entry-point')
void audioBrowser() => runApp(AudioBrowserWidget());

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
    required this.cameras,
  }) : super(key: key);
  final List<CameraDescription> cameras;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'NetTeam',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          initialRoute: "/splash",
          routes: {
            "/splash": (context) => const SplashScreen(),
            "/": (context) => const Home(),
            // "/": (context) => const NewHome(),
            "/login": (context) => Login(),
            "/signup": (context) => const SignUp(),
            "/forgotpassword": (context) => const ForgotPassword(),
            // "/verify": (context) => const Verify(),
            // "/resetpassword": (context) => const ResetPassword(),
            "/interests": (context) => const Interests(),
            // "/videocall": (context) => const VideoCall(),
            "/videoset": (context) => VideoSet(
                  cameras: cameras,
                ),
            // "/chat": (context) => Chat(),
            //"/live": (context) => const Live(),
            //"/video15": (context) => const Video15(),
            //"/video60": (context) => const Video60(),
            //"/video3m" : (context) => const Video3m(),
            "/chatlist": (context) => const ChatList(),
            "/profile": (context) => const Profile(),
            "/pricingplans": (context) => PricingPlans(),
            "/aboutyou": (context) => const AboutYou(),
            "/create": (context) => CreateVideoNew(
                  cameras: cameras,
                ),

            // "/create" : (context) => CreateVideo(cameras: cameras,),
            "/search": (context) => const Search(),
            "/userprofile": (context) => const UserProfile(),
            "/viewerslive": (context) => const ViewersLive(),
            // "/followers-following" : (context) => FollowersFollowing(),
          },
        );
      },
    );
  }
}
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({
//     Key? key,
//     this.title = '',
//   }) : super(key: key);
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
// // Set Banuba license token for Video Editor SDK
//   static const String LICENSE_TOKEN =
//       "rPuoCJSsO7N37D5lgDAYiTRKfl6KoEI4M7W1GH3HmBnIrkvZ5UFkfyXBArfdDPJ+ruILLhDjOrIbQji4RQLoFqZ6zIvTZOOVAcdrM/qGgzdNiv1jLHq12mexlUOOm7mxDBeuccYFsN5AggiYDzhEQAD42AxMTvFOvMP+3tmO8h9yOzUbFjK4AlOFL0jWE703NrxoOfEs6tPVfdrogn3OZwcpcVD8GbrpWUOAyivS9h65H/xtjN6tPcRTtoxZp2Pp2Hs/r+Id2/7WwqUx4N3+g75l5B1UwBsQv73upPFHmlNIbz7z/KJuSpNu5T+g26UlChfzQLzs3XEC96zTNXD7I/tIkZSHnBBWdnBLjTP8kDB+f1kG0WmkhUoP1opxJ0okBsAUqEf3y2XcnZvaMTQcK7co6qLwR46GBBFWieIVMfo/jBV/iUaAyLDFbAs6B8+ed0LO+7FCEeHhM5omyQ1/xZTzqmRg4curzydcLv0uphjsm0tgUiWOLXp6yrJR6z5GED1CG9ckvxr/DbHF9TqGYLWaP1cgdhoCZupWCzy+BRWkXJqV4kSkujHE/3zy40AER/Up4iCJuknDat3pIXgQwXtSKIUsZsmTeioLBOJoy6Y=";
//
//   static const channelName = 'startActivity/VideoEditorChannel';
//
//   static const methodInitVideoEditor = 'InitBanubaVideoEditor';
//   static const methodStartVideoEditor = 'StartBanubaVideoEditor';
//   static const methodStartVideoEditorPIP = 'StartBanubaVideoEditorPIP';
//   static const methodStartVideoEditorTrimmer = 'StartBanubaVideoEditorTrimmer';
//   static const methodDemoPlayExportedVideo = 'PlayExportedVideo';
//
//   static const errMissingExportResult = 'ERR_MISSING_EXPORT_RESULT';
//   static const errStartPIPMissingVideo = 'ERR_START_PIP_MISSING_VIDEO';
//   static const errStartTrimmerMissingVideo = 'ERR_START_TRIMMER_MISSING_VIDEO';
//   static const errExportPlayMissingVideo = 'ERR_EXPORT_PLAY_MISSING_VIDEO';
//
//   static const errEditorNotInitializedCode = 'ERR_VIDEO_EDITOR_NOT_INITIALIZED';
//   static const errEditorNotInitializedMessage =
//       'Banuba Video Editor SDK is not initialized: license token is unknown or incorrect.\nPlease check your license token or contact Banuba';
//   static const errEditorLicenseRevokedCode = 'ERR_VIDEO_EDITOR_LICENSE_REVOKED';
//   static const errEditorLicenseRevokedMessage =
//       'License is revoked or expired. Please contact Banuba https://www.banuba.com/faq/kb-tickets/new';
//
//   static const argExportedVideoFile = 'exportedVideoFilePath';
//   static const argExportedVideoCoverPreviewPath =
//       'exportedVideoCoverPreviewPath';
//
//   static const platform = MethodChannel(channelName);
//
//   String _errorMessage = '';
//
//   Future<void> _initVideoEditor() async {
//     await platform.invokeMethod(methodInitVideoEditor, LICENSE_TOKEN);
//   }
//
//   Future<void> _startVideoEditorDefault() async {
//     try {
//       await _initVideoEditor();
//
//       final result = await platform.invokeMethod(methodStartVideoEditor);
//
//       _handleExportResult(result);
//     } on PlatformException catch (e) {
//       _handlePlatformException(e);
//     }
//   }
//
//   void _handleExportResult(dynamic result) {
//     debugPrint('Export result = $result');
//
//     // You can use any kind of export result passed from platform.
//     // Map is used for this sample to demonstrate playing exported video file.
//     if (result is Map) {
//       final exportedVideoFilePath = result[argExportedVideoFile];
//
//       // Use video cover preview to meet your requirements
//       final exportedVideoCoverPreviewPath =
//           result[argExportedVideoCoverPreviewPath];
//
//       _showConfirmation(context, "Play exported video file?", () {
//         platform.invokeMethod(
//             methodDemoPlayExportedVideo, exportedVideoFilePath);
//       });
//     }
//   }
//
//   Future<void> _startVideoEditorPIP() async {
//     try {
//       await _initVideoEditor();
//
//       // Use your implementation to provide correct video file path to start Video Editor SDK in PIP mode
//       final ImagePicker _picker = ImagePicker();
//       final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
//
//       if (file == null) {
//         debugPrint(
//             'Cannot open video editor with PIP - video was not selected!');
//       } else {
//         debugPrint('Open video editor in pip with video = ${file.path}');
//         final result =
//             await platform.invokeMethod(methodStartVideoEditorPIP, file.path);
//
//         _handleExportResult(result);
//       }
//     } on PlatformException catch (e) {
//       _handlePlatformException(e);
//     }
//   }
//
//   Future<void> _startVideoEditorTrimmer() async {
//     try {
//       await _initVideoEditor();
//
//       // Use your implementation to provide correct video file path to start Video Editor SDK in Trimmer mode
//       final ImagePicker _picker = ImagePicker();
//       final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
//
//       if (file == null) {
//         debugPrint(
//             'Cannot open video editor with Trimmer - video was not selected!');
//       } else {
//         debugPrint('Open video editor in trimmer with video = ${file.path}');
//         final result = await platform.invokeMethod(
//             methodStartVideoEditorTrimmer, file.path);
//
//         _handleExportResult(result);
//       }
//     } on PlatformException catch (e) {
//       _handlePlatformException(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Padding(
//               padding: EdgeInsets.all(15.0),
//               child: Text(
//                 'The sample demonstrates how to run Banuba Video Editor SDK with Flutter',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 17.0,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(15.0),
//               child: Linkify(
//                 text: _errorMessage,
//                 onOpen: (link) async {
//                   if (await canLaunchUrlString(link.url)) {
//                     await launchUrlString(link.url);
//                   } else {
//                     throw 'Could not launch $link';
//                   }
//                 },
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14.0,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.redAccent,
//                 ),
//               ),
//             ),
//             MaterialButton(
//               color: Colors.blue,
//               textColor: Colors.white,
//               disabledColor: Colors.grey,
//               disabledTextColor: Colors.black,
//               padding: const EdgeInsets.all(12.0),
//               splashColor: Colors.blueAccent,
//               minWidth: 240,
//               onPressed: () => _startVideoEditorDefault(),
//               child: const Text(
//                 'Open Video Editor - Default',
//                 style: TextStyle(
//                   fontSize: 14.0,
//                 ),
//               ),
//             ),
//             SizedBox(height: 24),
//             MaterialButton(
//               color: Colors.green,
//               textColor: Colors.white,
//               disabledColor: Colors.grey,
//               disabledTextColor: Colors.black,
//               padding: const EdgeInsets.all(16.0),
//               splashColor: Colors.greenAccent,
//               minWidth: 240,
//               onPressed: () => _startVideoEditorPIP(),
//               child: const Text(
//                 'Open Video Editor - PIP',
//                 style: TextStyle(
//                   fontSize: 14.0,
//                 ),
//               ),
//             ),
//             SizedBox(height: 24),
//             MaterialButton(
//               color: Colors.red,
//               textColor: Colors.white,
//               disabledColor: Colors.grey,
//               disabledTextColor: Colors.black,
//               padding: const EdgeInsets.all(16.0),
//               splashColor: Colors.redAccent,
//               minWidth: 240,
//               onPressed: () => _startVideoEditorTrimmer(),
//               child: const Text(
//                 'Open Video Editor - Trimmer',
//                 style: TextStyle(
//                   fontSize: 14.0,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Handle exceptions thrown on Android, iOS platform while opening Video Editor SDK
//   void _handlePlatformException(PlatformException exception) {
//     debugPrint("Error: '${exception.message}'.");
//
//     String errorMessage = '';
//     switch (exception.code) {
//       case errEditorLicenseRevokedCode:
//         errorMessage = errEditorLicenseRevokedMessage;
//         break;
//       case errEditorNotInitializedCode:
//         errorMessage = errEditorNotInitializedMessage;
//         break;
//       default:
//         errorMessage = 'unknown error';
//     }
//
//     _errorMessage = errorMessage;
//     setState(() {});
//   }
//
//   void _showConfirmation(
//       BuildContext context, String message, VoidCallback block) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(message),
//         actions: [
//           MaterialButton(
//             color: Colors.red,
//             textColor: Colors.white,
//             disabledColor: Colors.grey,
//             disabledTextColor: Colors.black,
//             padding: const EdgeInsets.all(12.0),
//             splashColor: Colors.redAccent,
//             onPressed: () => {Navigator.pop(context)},
//             child: const Text(
//               'Cancel',
//               style: TextStyle(
//                 fontSize: 14.0,
//               ),
//             ),
//           ),
//           MaterialButton(
//             color: Colors.green,
//             textColor: Colors.white,
//             disabledColor: Colors.grey,
//             disabledTextColor: Colors.black,
//             padding: const EdgeInsets.all(12.0),
//             splashColor: Colors.greenAccent,
//             onPressed: () {
//               Navigator.pop(context);
//               block.call();
//             },
//             child: const Text(
//               'Ok',
//               style: TextStyle(
//                 fontSize: 14.0,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
