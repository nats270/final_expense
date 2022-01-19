import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signup/Screens/Welcome/components/background.dart';
import 'package:signup/components/rounded_button.dart';
import 'package:signup/constants.dart';
import 'package:signup/newScreens/login_screen.dart';

import '../../home_screen.dart';

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //this size screen width and height
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'EXPENSE TRACKER',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.03),
            // RoundedButton(
            //   text: "LOGIN",
            //   color: kPrimaryColor,
            //   press: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) {
            //           return NewLoginScreen();
            //         },
            //       ),
            //     );
            //   },
            // ),
            RoundedButton(
              text: "Welcome",
              color: kPrimaryColor,
              textColor: Colors.white,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const HomeScreen();
                    },
                  ),
                );
              },
            ),
            // Text(),
            // Text("email"),
        RoundedButton(
              text:
                'LogOut',
              color: kPrimaryLightColor,
              press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewLoginScreen()));
                  //Navigator.pop(context);
                },),
          ],
        ),
      ),
    );
  }
}
