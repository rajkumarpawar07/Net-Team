import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PricingPlans extends StatefulWidget {
  PricingPlans({Key? key}) : super(key: key);

  @override
  State<PricingPlans> createState() => _PricingPlansState();
}

class _PricingPlansState extends State<PricingPlans> {
  late int itemIndex;
  late PageController _controller = PageController(initialPage: itemIndex);

  //Integrating payment gateways need to be made the onBuy function defined in the below pricing plans
  final List<PricingDetails> _details = [
    PricingDetails(
        name: "Silver",
        price: 99,
        features: <String>["Feature 1", "Feature 2", "Feature 3"],
        onBuy: () {
          print("Buying Silver Plan");
        }),
    PricingDetails(
        name: "Gold",
        price: 149,
        features: <String>["Feature 1", "Feature 2", "Feature 3"],
        onBuy: () {
          print("Buying Gold Plan");
        }),
    PricingDetails(
        name: "Platinum",
        price: 199,
        features: <String>["Feature 1", "Feature 2", "Feature 3"],
        onBuy: () {
          print("Buying Platinum Plan");
        }),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    itemIndex = ModalRoute.of(context)?.settings.arguments as int;
    //_controller.initialPage = itemIndex ;
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
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50.h,
              ),
              SizedBox(
                height: 500.h,
                width: 370.w,
                child: PageView.builder(
                    controller: _controller,
                    pageSnapping: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _details.length,
                    onPageChanged: (i) {
                      setState(() {
                        itemIndex = i;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      PricingDetails plan = _details[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            plan.name,
                            style: GoogleFonts.roboto(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.white60))),
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 30.w),
                                  child: Text("INR",
                                      style: GoogleFonts.roboto(
                              fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 50.w),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        plan.price.toString(),
                                        style: GoogleFonts.roboto(
                                            fontSize: 50.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "/month",
                                        style: GoogleFonts.roboto(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 60.h,
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: plan.features.length,
                                  itemBuilder: (BuildContext context, int j) {
                                    String feature = plan.features[j];
                                    return Column(
                                      children: [
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
                                              feature,
                                              style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15.sp,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        )
                                      ],
                                    );
                                  })),
                          SizedBox(
                            height: 50.h,
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 50.h,
                                  width: 250.w,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25.r)),
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xFFDA010A)),
                                        ),
                                        onPressed: () {
                                          _details[index].onBuy();
                                        },
                                        child: Text(
                                          "Buy Now",
                                          style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  "Terms and Conditions",
                                  style: GoogleFonts.roboto(
                                    fontSize: 10.sp,
                                    color: Colors.white60,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    }),
              ),
              SizedBox(
                height: 50.h,
              ),
              Center(
                  child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25.r)),
                    child: Container(
                      height: 10.h,
                      width: (itemIndex == 0) ? 30.w : 10.h,
                      color: (itemIndex == 0) ? Colors.white : Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25.r)),
                    child: Container(
                      height: 10.h,
                      width: (itemIndex == 1) ? 30.w : 10.h,
                      color: (itemIndex == 1) ? Colors.white : Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25.r)),
                    child: Container(
                      height: 10.h,
                      width: (itemIndex == 2) ? 30.w : 10.h,
                      color: (itemIndex == 2) ? Colors.white : Colors.grey,
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      )),
    );
  }
}

class PricingDetails {
  String name;
  int price;
  List<String> features;
  Function onBuy;
  PricingDetails(
      {required this.name,
      required this.price,
      required this.features,
      required this.onBuy});
}
