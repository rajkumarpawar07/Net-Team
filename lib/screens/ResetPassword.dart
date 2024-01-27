import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key,required this.email}) : super(key: key);
  final String email;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  var _showPassword = false;
  var _showPassword1 = false;
  bool _isError = false;
  String password = '';
  String password1 = '';

  Future<void> setNewPassword() async {
    String apiUrl = "${dotenv.env['BACKEND_URL']}/change-password";

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(<String,dynamic>{
            "userId": widget.email,
            "password": password,
          })
      );

      if (response.statusCode == 200) {
        setState(() {
          Navigator.pushNamed(context, "/login");
        });
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0B1F),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFF0E0B1F),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60.h,
                ),
                SizedBox(
                  width: 250.w,
                  child: Text(
                    "Reset password",
                    style: GoogleFonts.roboto(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  width: 227.w,
                  child: Text(
                    "Enter the new password in the following input fields",
                    style: GoogleFonts.roboto(
                        color: const Color(0xFF8D92A3),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 295.w,
                        child: TextField(
                          obscureText: !_showPassword,
                          controller: _passwordController,
                          decoration: InputDecoration(
                              //contentPadding: EdgeInsets.only(bottom: 10),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xFF9F9F9F),
                                size: 20,
                              ),
                              hintText: 'Password',
                              errorText:
                                  _isError ? "Enter same password" : null,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                  icon: Icon(
                                    _showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color(0xFF9F9F9F),
                                    size: 20,
                                  )),
                              hintStyle: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF9F9F9F),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF9F9F9F)))),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              _isError = false;
                              password = _passwordController.text;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      SizedBox(
                        width: 295.w,
                        child: TextField(
                          obscureText: !_showPassword1,
                          controller: _passwordController1,
                          decoration: InputDecoration(
                              //contentPadding: EdgeInsets.only(bottom: 10),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color(0xFF9F9F9F),
                                size: 20,
                              ),
                              hintText: 'Confirm Password',
                              errorText:
                                  _isError ? "Enter same password" : null,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _showPassword1 = !_showPassword1;
                                    });
                                  },
                                  icon: Icon(
                                    _showPassword1
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color(0xFF9F9F9F),
                                    size: 20,
                                  )),
                              hintStyle: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF9F9F9F),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF9F9F9F)))),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              _isError = false;
                              password1 = _passwordController1.text;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 60.h,
                      ),
                      SizedBox(
                        height: 46.h,
                        width: 295.w,
                        child: ElevatedButton(
                          onPressed: () {
                            if (password != password1) {
                              setState(() {
                                _isError = true;
                              });
                            } else {
                              //Navigate to Home Screen
                              setNewPassword();
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFFCBFB5E))),
                          child: Text(
                            "CHANGE PASSWORD",
                            style: GoogleFonts.roboto(
                                color: const Color(0xFF20242F),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
