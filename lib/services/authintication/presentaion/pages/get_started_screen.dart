import 'package:cleanapp/core/ui_constants/border_radius.dart';
import 'package:cleanapp/services/authintication/presentaion/pages/Login_screen.dart';
import 'package:cleanapp/services/authintication/presentaion/pages/username_screen.dart';
import 'package:cleanapp/services/localization/app_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/ui_constants/colors.dart';
import '../../../../core/ui_constants/fonts.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/aa.jpg"), fit: BoxFit.fill)),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  third_color,
                  secondary_color,
                  third_color,
                  Colors.transparent
                ]),
          ),
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width,
                height: 40,
                child: const Text(
                  "Welcome",
                  style: TextStyle(
                    fontFamily: font_en,
                    color: text_secondary_color,
                    fontSize: 30,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                height: 40,
                child: const Text(
                  'FiPay: The best multifunctional digital E-Wallet of this century.',
                  style: TextStyle(
                      fontFamily: font_en,
                      fontSize: body_font_size,
                      color: text_secondary_color),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: size.width,
                height: 55,
                child: ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(text_secondary_color),
                      backgroundColor: MaterialStateProperty.all(primary_color),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(DEFAULT_BORDER_RADIUS)))),
                  child: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                          fontSize: large_font_size, fontFamily: font_en),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UsernameScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
