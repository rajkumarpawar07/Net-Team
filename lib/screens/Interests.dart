import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../main.dart';

class InterestData {
  String name;
  String imagePath;
  bool isSelected;
  InterestData(
      {required this.name, required this.imagePath, required this.isSelected});
}

class Interests extends StatefulWidget {
  const Interests({Key? key}) : super(key: key);

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late MyDataContainer dataContainer;
  late String id;
  late List<String> oldInterests;

  final List<InterestData> _professional = <InterestData>[
    InterestData(
        name: "Accountancy",
        imagePath: './assets/images/accountancy.png',
        isSelected: false),
    InterestData(
        name: "Consulting",
        imagePath: './assets/images/consulting.png',
        isSelected: false),
    InterestData(
        name: "Music",
        imagePath: "./assets/images/music.png",
        isSelected: false),
    InterestData(
        name: "Farming",
        imagePath: "./assets/images/farming.png",
        isSelected: false),
    InterestData(
        name: "Fintech",
        imagePath: "./assets/images/fintech.png",
        isSelected: false),
    InterestData(
        name: "Edtech",
        imagePath: "./assets/images/edtech.png",
        isSelected: false),
    InterestData(
        name: "IT Security",
        imagePath: "./assets/images/itsecurity.png",
        isSelected: false),
    InterestData(
        name: "Management",
        imagePath: "./assets/images/management.png",
        isSelected: false),
    InterestData(
        name: "Sales and Marketing",
        imagePath: "./assets/images/sam.png",
        isSelected: false),
    InterestData(
        name: "Advertisement",
        imagePath: "./assets/images/advertisement.png",
        isSelected: false),
  ];

  final List<InterestData> _student = <InterestData>[
    InterestData(
        name: "Science",
        imagePath: './assets/images/science.png',
        isSelected: false),
    InterestData(
        name: "Arts", imagePath: './assets/images/arts.png', isSelected: false),
    InterestData(
        name: "Computer",
        imagePath: "./assets/images/computer.png",
        isSelected: false),
    InterestData(
        name: "Law", imagePath: "./assets/images/law.png", isSelected: false),
    InterestData(
        name: "Medical",
        imagePath: "./assets/images/medical.png",
        isSelected: false),
    InterestData(
        name: "Finance",
        imagePath: "./assets/images/finance.png",
        isSelected: false),
    InterestData(
        name: "Business",
        imagePath: "./assets/images/business.png",
        isSelected: false),
    InterestData(
        name: "Military",
        imagePath: "./assets/images/military.png",
        isSelected: false),
    InterestData(
        name: "Hotel Management",
        imagePath: "./assets/images/HM.png",
        isSelected: false),
    InterestData(
        name: "Astranomy",
        imagePath: "./assets/images/astranomy.png",
        isSelected: false),
  ];

  final List<InterestData> _general = <InterestData>[
    InterestData(
        name: "Singing",
        imagePath: './assets/images/singing.png',
        isSelected: false),
    InterestData(
        name: "Dancing",
        imagePath: './assets/images/dancing.png',
        isSelected: false),
    InterestData(
        name: "Reading",
        imagePath: "./assets/images/reading.png",
        isSelected: false),
    InterestData(
        name: "Cricket",
        imagePath: "./assets/images/cricket.png",
        isSelected: false),
    InterestData(
        name: "Badminton",
        imagePath: "./assets/images/badminton.png",
        isSelected: false),
    InterestData(
        name: "Gym", imagePath: "./assets/images/gym.png", isSelected: false),
    InterestData(
        name: "Bowling",
        imagePath: "./assets/images/bowling.png",
        isSelected: false),
    InterestData(
        name: "Concerts",
        imagePath: "./assets/images/concerts.png",
        isSelected: false),
    InterestData(
        name: "Festivals",
        imagePath: "./assets/images/festivals.png",
        isSelected: false),
    InterestData(
        name: "Crafts",
        imagePath: "./assets/images/crafts.png",
        isSelected: false),
  ];

  TextEditingController _interestController = TextEditingController();

  void _addInterest(List a, String interest) {
    setState(() {
      a.add(InterestData(name: interest, imagePath: '', isSelected: true));
    });
    _interestController.clear();
  }

  void _showAddInterestDialog(List a) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Interest'),
          backgroundColor: const Color(0xFF0E0B1F),
          content: TextFormField(
            controller: _interestController,
            decoration: InputDecoration(
                labelText: 'Interest',
                labelStyle: TextStyle(color: Colors.grey)),
            onFieldSubmitted: (value) {
              _addInterest(a, value);
              Navigator.of(context).pop();
            },
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Color(0xFF1EA7D7))),
              onPressed: () {
                _addInterest(a, _interestController.text);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'System Response',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<String> interests = [];

  Future<void> storeInterests() async {
    _professional.forEach((e) {
      if (e.isSelected) {
        interests.add(e.name);
      }
    });
    _student.forEach((e) {
      if (e.isSelected) {
        interests.add(e.name);
      }
    });
    _general.forEach((e) {
      if (e.isSelected) {
        interests.add(e.name);
      }
    });

    var url = Uri.parse(
        '${dotenv.env['BACKEND_URL']}/storeInterests'); // Replace with your API endpoint URL
    // 'http://192.168.1.16:4000/storeInterests'); // Replace with your API endpoint URL

    print(id);
    print(interests);
    try {
      var requestBody = json.encode({
        '_id': id,
        'interests': interests,
      });
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Interests added successfully
        if (oldInterests.isEmpty) {
          dataContainer.updateData("", "", "", "", "", "", []);
          print('Interests added successfully');
          Navigator.pop(context);
        } else {
          setState(() {
            Provider.of<MyDataContainer>(context, listen: false).interests =
                interests;
            Navigator.pushReplacementNamed(context, "/profile");
          });
        }
      } else {
        // Interests addition failed
        print(
            'Interst addition failed with status code: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (e) {
      print("error ${e}");
    }
  }

  int get professionalSelected {
    return _professional.where((e) => e.isSelected).length;
  }

  int get studentSelected {
    return _student.where((element) => element.isSelected).length;
  }

  int get generalSelected {
    return _general.where((e) => e.isSelected).length;
  }

  @override
  Widget build(BuildContext context) {
    id = Provider.of<MyDataContainer>(context).id;
    oldInterests = Provider.of<MyDataContainer>(context).interests;
    dataContainer = Provider.of<MyDataContainer>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF0E0B1F),
        title: Text(
          "Interests",
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500,
              fontSize: 20.sp,
              color: Colors.white),
        ),
        elevation: 0.0,
      ),
      backgroundColor: const Color(0xFF0E0B1F),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Professional",
                          style: GoogleFonts.roboto(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Wrap(
                            spacing: 6,
                            runSpacing: 10,
                            children: _professional
                                    .map((e) => GestureDetector(
                                          onTap: () => {
                                            setState(() {
                                              e.isSelected = !e.isSelected;
                                            })
                                          },
                                          child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  5.w, 4.h, 5.w, 4.h),
                                              decoration: BoxDecoration(
                                                  color: e.isSelected
                                                      ? const Color(0xFFEF3737)
                                                      : const Color(0xFFFFFFFF),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.h)),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  (e.imagePath != "")
                                                      ? Image.asset(
                                                          e.imagePath,
                                                          height: 12.h,
                                                          width: 12.h,
                                                        )
                                                      : SizedBox(
                                                          height: 1.h,
                                                        ),
                                                  SizedBox(
                                                    width: 4.w,
                                                  ),
                                                  Text(
                                                    e.name,
                                                    style: GoogleFonts.roboto(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12.sp,
                                                        color: e.isSelected
                                                            ? Colors.white
                                                            : const Color(
                                                                0xFF001AFF)),
                                                  )
                                                ],
                                              )),
                                        ))
                                    .toList() +
                                [
                                  GestureDetector(
                                    onTap: () => {
                                      //Add new Interests
                                      _showAddInterestDialog(_professional)
                                    },
                                    child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                            5.w, 4.h, 5.w, 4.h),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFFFFFFF),
                                            borderRadius:
                                                BorderRadius.circular(20.h)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Others",
                                              style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12.sp,
                                                  color:
                                                      const Color(0xFF001AFF)),
                                            )
                                          ],
                                        )),
                                  )
                                ]),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                            "*You have selected ${professionalSelected} out of ${_professional.length}",
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.normal,
                                fontSize: 12.sp,
                                color: const Color(0xFF868686)))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Student",
                          style: GoogleFonts.roboto(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Wrap(
                            spacing: 6,
                            runSpacing: 10,
                            children: _student
                                    .map((e) => GestureDetector(
                                          onTap: () => {
                                            setState(() {
                                              e.isSelected = !e.isSelected;
                                            })
                                          },
                                          child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  5.w, 4.h, 5.w, 4.h),
                                              decoration: BoxDecoration(
                                                  color: e.isSelected
                                                      ? const Color(0xFFEF3737)
                                                      : const Color(0xFFFFFFFF),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.h)),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  (e.imagePath != "")
                                                      ? Image.asset(
                                                          e.imagePath,
                                                          height: 12.h,
                                                          width: 12.h,
                                                        )
                                                      : SizedBox(
                                                          height: 1.h,
                                                        ),
                                                  SizedBox(
                                                    width: 4.w,
                                                  ),
                                                  Text(
                                                    e.name,
                                                    style: GoogleFonts.roboto(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12.sp,
                                                        color: e.isSelected
                                                            ? Colors.white
                                                            : const Color(
                                                                0xFF001AFF)),
                                                  )
                                                ],
                                              )),
                                        ))
                                    .toList() +
                                [
                                  GestureDetector(
                                    onTap: () => {
                                      //Add new Interests
                                      _showAddInterestDialog(_student)
                                    },
                                    child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                            5.w, 4.h, 5.w, 4.h),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFFFFFFF),
                                            borderRadius:
                                                BorderRadius.circular(20.h)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Others",
                                              style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12.sp,
                                                  color:
                                                      const Color(0xFF001AFF)),
                                            )
                                          ],
                                        )),
                                  )
                                ]),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                            "*You have selected ${studentSelected} out of ${_student.length}",
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.normal,
                                fontSize: 12.sp,
                                color: const Color(0xFF868686)))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "General",
                          style: GoogleFonts.roboto(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Wrap(
                            spacing: 6,
                            runSpacing: 10,
                            children: _general
                                    .map((e) => GestureDetector(
                                          onTap: () => {
                                            setState(() {
                                              e.isSelected = !e.isSelected;
                                            })
                                          },
                                          child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  5.w, 4.h, 5.w, 4.h),
                                              decoration: BoxDecoration(
                                                  color: e.isSelected
                                                      ? const Color(0xFFEF3737)
                                                      : const Color(0xFFFFFFFF),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.h)),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  (e.imagePath != "")
                                                      ? Image.asset(
                                                          e.imagePath,
                                                          height: 12.h,
                                                          width: 12.h,
                                                        )
                                                      : SizedBox(
                                                          height: 1.h,
                                                        ),
                                                  SizedBox(
                                                    width: 4.w,
                                                  ),
                                                  Text(
                                                    e.name,
                                                    style: GoogleFonts.roboto(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12.sp,
                                                        color: e.isSelected
                                                            ? Colors.white
                                                            : const Color(
                                                                0xFF001AFF)),
                                                  )
                                                ],
                                              )),
                                        ))
                                    .toList() +
                                [
                                  GestureDetector(
                                    onTap: () => {
                                      //Add new Interests
                                      _showAddInterestDialog(_general)
                                    },
                                    child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                            5.w, 4.h, 5.w, 4.h),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFFFFFFF),
                                            borderRadius:
                                                BorderRadius.circular(20.h)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Others",
                                              style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12.sp,
                                                  color:
                                                      const Color(0xFF001AFF)),
                                            )
                                          ],
                                        )),
                                  )
                                ]),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                            "*You have selected ${generalSelected} out of ${_general.length}",
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.normal,
                                fontSize: 12.sp,
                                color: const Color(0xFF868686)))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 80.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (professionalSelected > 0 &&
                              studentSelected > 0 &&
                              generalSelected > 0) {
                            storeInterests();
                          } else {
                            showAlertDialog(context,
                                'Select atleast 1 interest from every field!');
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFF1EA7D7)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                        child: Text(
                          "Save",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                              color: Colors.white),
                        ))
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
