import 'dart:convert';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../main.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  var _showPassword = false;
  var _showPassword1 = false;
  bool _isError = false;
  bool _isEmailError = false;
  String password = '';
  String password1 = '';
  String email = '';
  String name = '';
  late MyDataContainer dataContainer;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    return EmailValidator.validate(email);
  }

  Future<void> signUp(String username, String email, String password) async {
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('${dotenv.env['BACKEND_URL']}/signup');
    print(username);
    print(email);
    print(password);

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': username,
          'email': email,
          'password': password,
        }),
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        print("signup response ${response.body}");
        // Signup successful
        print('Signup successful');
        ElegantNotification.success(
                title: Text("Success"),
                description: Text("Account created successfully"))
            .show(context);
        dataContainer.updateData(
            json.decode(response.body)["_ID"] ?? "", "", "", "", "", "", []);
        Navigator.pop(context);
        Navigator.pushNamed(context, "/interests");
      } else {
        setState(() {
          _isLoading = false;
        });
        // Signup failed
        ElegantNotification.error(
                title: Text("Error"),
                description: Text("Error creating user account"))
            .show(context);
        print('Signup failed with status code: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (e) {
      ElegantNotification.error(
              title: Text("Error"),
              description: Text("Error creating user account"))
          .show(context);
      setState(() {
        _isLoading = false;
      });
      print("error ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    dataContainer = Provider.of<MyDataContainer>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0E0B1F),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80.h,
                ),
                Text(
                  "SIGN IN",
                  style: GoogleFonts.roboto(
                      fontSize: 36.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50.h,
                ),
                SizedBox(
                  width: 295.w,
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 15),
                        prefixIcon: Icon(
                          Icons.account_circle_outlined,
                          color: Color(0xFF9F9F9F),
                          size: 20,
                        ),
                        hintText: 'Name',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF9F9F9F),
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF9F9F9F)))),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        name = _nameController.text;
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
                    controller: _emailController,
                    decoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(bottom: 15),
                        prefixIcon: const Icon(
                          Icons.alternate_email_outlined,
                          color: Color(0xFF9F9F9F),
                          size: 20,
                        ),
                        hintText: 'Email',
                        errorText: _isEmailError
                            ? "Kindly enter the email properly"
                            : null,
                        hintStyle: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF9F9F9F),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF9F9F9F)))),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        _isEmailError = false;
                        email = _emailController.text;
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
                        errorText: _isError ? "Enter same password" : null,
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
                            borderSide: BorderSide(color: Color(0xFF9F9F9F)))),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      if (!isValidEmail(email)) {
                        setState(() {
                          _isEmailError = true;
                        });
                      }
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
                        errorText: _isError ? "Enter same password" : null,
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
                            borderSide: BorderSide(color: Color(0xFF9F9F9F)))),
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
                  height: 80.h,
                ),
                SizedBox(
                  height: 46.h,
                  width: 295.w,
                  child: ElevatedButton(
                    onPressed: () {
                      if ((password != password1) && (!isValidEmail(email))) {
                        setState(() {
                          _isError = true;
                          _isEmailError = true;
                        });
                      } else if (!isValidEmail(email)) {
                        setState(() {
                          _isEmailError = true;
                        });
                      } else if (password != password1) {
                        setState(() {
                          _isError = true;
                        });
                      } else {
                        //Navigate to Interests Screen
                        signUp(name, email, password);
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFCBFB5E))),
                    child: _isLoading
                        ? Center(
                            child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                    color: Colors.black)),
                          )
                        : Text(
                            "SIGN UP",
                            style: GoogleFonts.roboto(
                                color: const Color(0xFF20242F),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Row(
                  children: [
                    const Expanded(
                        child: Divider(
                      color: Color(0xFF8D92A3),
                    )),
                    Text(
                      "    Or connect with    ",
                      style: GoogleFonts.roboto(
                        color: const Color(0xFF8D92A3),
                        fontWeight: FontWeight.bold,
                        fontSize: 11.sp,
                      ),
                    ),
                    const Expanded(
                        child: Divider(
                      color: Color(0xFF8D92A3),
                    )),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.facebook,
                        color: Colors.white,
                        size: 40.h,
                      ),
                      onPressed: () {
                        //Handle respective event
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.g_mobiledata,
                        color: Colors.white,
                        size: 50.h,
                      ),
                      onPressed: () {
                        //Handle respective event
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.apple,
                        color: Colors.white,
                        size: 40.h,
                      ),
                      onPressed: () {
                        //Handle respective event
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 50.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/login");
                      },
                      child: Text(
                        "Already have an account?",
                        style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/login");
                      },
                      child: Text(
                        " Sign In",
                        style: GoogleFonts.roboto(
                            color: const Color(0xFFCBFB5E),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
