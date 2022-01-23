// import 'dart:core';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:expense_app_new/Screens/Welcome/components/background.dart';
// import 'package:expense_app_new/components/rounded_button.dart';
// import 'package:expense_app_new/constants.dart';
// import 'package:expense_app_new/newScreens/login_screen.dart';
// import 'package:expense_app_new/newScreens/registration_screen.dart';
//
// import '../../home_screen.dart';
//
// class Body extends StatelessWidget {
//   const Body({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     //this size screen width and height
//     return Background(
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'EXPENSE TRACKER',
//               style: TextStyle(fontWeight: FontWeight.w800),
//             ),
//             SizedBox(height: size.height * 0.03),
//             SvgPicture.asset(
//               "assets/icons/chat.svg",
//               height: size.height * 0.45,
//             ),
//             SizedBox(height: size.height * 0.03),
//             // RoundedButton(
//             //   text: "LOGIN",
//             //   color: kPrimaryColor,
//             //   press: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(
//             //         builder: (context) {
//             //           return NewLoginScreen();
//             //         },
//             //       ),
//             //     );
//             //   },
//             // ),
//             RoundedButton(
//               text: "Login",
//               color: kPrimaryLightColor,
//               textColor: kPrimaryColor,
//               press: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return const NewLoginScreen();
//                     },
//                   ),
//                 );
//               },
//             ),
//             RoundedButton(
//               text: "LogOut",
//               color: kPrimaryColor,
//               textColor: kPrimaryLightColor,
//               press: () {
//                 logout(context);
//               },
//             ),
//         RoundedButton(
//               text:
//                 'SignUp',
//               color: kPrimaryLightColor,
//               textColor: kPrimaryColor,
//               press: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationScreen()));
//                   //Navigator.pop(context);
//                 },),
//           ],
//         ),
//       ),
//     );
//   }
//   Future<void> logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const NewLoginScreen()));
//   }
// }
