import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'Home.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences? prefs;
  String? _token;
  MyDataContainer? dataContainer;

  Future<void> _initToken() async {
    prefs = await SharedPreferences.getInstance();
    _token = prefs?.getString('Authorization') ?? "";
    String yourToken = _token!;
    print("token ${yourToken}");
    if (yourToken.isNotEmpty) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(yourToken);
      print("jwt decoder ${decodedToken}");
      dataContainer?.updateData(
          decodedToken["_id"] ?? "",
          decodedToken["name"] ?? "",
          decodedToken["profilePic"] ?? "",
          decodedToken["fancyId"] ?? "",
          decodedToken["email"] ?? "",
          decodedToken["socialId"] ?? "",
          List<String>.from(decodedToken["interests"] ?? ""));
    }
  }

  @override
  void initState() {
    super.initState();

    _initToken();

    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: ((context) =>
                    _token!.isNotEmpty ? Home() : Login()))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF0E0B1F),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFEA0614), Color(0xFF3D89CB)])),
          child: Center(
            child: Image.asset(
              "assets/images/1.0.png",
              height: 150.h,
            ),
          ),
        ));
  }
}
