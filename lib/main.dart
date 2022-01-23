import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:expense_app_new/constants.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'Screens/Welcome/welcome_screen.dart';
import 'Screens/WelcomeHome/welcome_home_screen.dart';

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
        canvasColor: kPrimaryLightColor,
        //static const MaterialColor _2A363B = MaterialColor(0xff2A363B, colorMap);
        primaryColor: kPrimaryColor,
        //primarySwatch: kPrimaryLightColor,
        textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme),
        //scaffoldBackgroundColor: Colors.white,
      ),
      //home: const NewLoginScreen(),
      home: const WelcomeHomeScreen(),
    );
  }
}
