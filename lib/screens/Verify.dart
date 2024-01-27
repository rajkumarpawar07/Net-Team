import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:http/http.dart' as http;

import 'ResetPassword.dart';

class Verify extends StatefulWidget {
  const Verify({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  TextEditingController newTextEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  late String OTP;

  Future<String> sendEmail() async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/send-email";

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String, dynamic>{
            "email": widget.email,
          }));

      if (response.statusCode == 200) {
        final otp = json.decode(response.body);
        return otp;
      } else if (response.statusCode == 404) {
        // User not found
        // Handle the error accordingly
      } else {
        // Other error occurred
        // Handle the error accordingly
      }
    } catch (error) {
      // Error occurred during the API call
      // Handle the error accordingly
    }
    return "";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sendEmail().then((otp) => {
          if (otp != "") {OTP = otp}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0B1F),
        elevation: 0.0,
      ),
      backgroundColor: Color(0xFF0E0B1F),
      body: SafeArea(
        child: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60.h,
                  ),
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      "Verify email",
                      style: GoogleFonts.roboto(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    width: 250.w,
                    child: Text(
                      "Enter the OTP which is sent to your registered email",
                      style: GoogleFonts.roboto(
                          color: const Color(0xFF8D92A3),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    height: 70.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 250.w,
                        child: PinCodeFields(
                          length: 4,
                          controller: newTextEditingController,
                          focusNode: focusNode,
                          onComplete: (result) {
                            // Your logic with code
                            print(result);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 46.h,
                        width: 295.w,
                        child: ElevatedButton(
                          onPressed: () {
                            if (OTP == newTextEditingController.text) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ResetPassword(email: widget.email)));
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFFCBFB5E))),
                          child: Text(
                            "CONTINUE",
                            style: GoogleFonts.roboto(
                                color: const Color(0xFF20242F),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 46.h,
                        width: 295.w,
                        child: ElevatedButton(
                          onPressed: () {
                            sendEmail().then((otp) => {
                                  if (otp != "") {OTP = otp}
                                });
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF0E0B1F))),
                          child: Text(
                            "Resend OTP",
                            style: GoogleFonts.roboto(
                                color: const Color(0xFFCBFB5E),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
