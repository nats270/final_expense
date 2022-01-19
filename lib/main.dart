import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:signup/constants.dart';

import 'newScreens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        //static const MaterialColor _2A363B = MaterialColor(0xff2A363B, colorMap);

        primaryColor: kPrimaryColor,
        //scaffoldBackgroundColor: Colors.white,
      ),
      home: const NewLoginScreen(),
    );
  }
}
