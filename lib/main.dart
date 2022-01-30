import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signup/Screens/home_screen.dart';
import 'package:signup/Screens/login_screen.dart';
import 'package:signup/Screens/monthwise_transaction_page.dart';
import 'package:signup/Screens/option_page.dart';
import 'package:signup/Screens/registration_screen.dart';
import 'package:signup/Screens/reset_password_screen.dart';
import 'package:signup/Screens/sync_sms_screen.dart';

import 'constants.dart';

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
        primaryColor: kPrimaryColor,
        textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme),
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        MonthWiseTransactionPage.routeName: (_) => const MonthWiseTransactionPage(),
        OptionsPage.routeName: (_) => const OptionsPage(),
        RegistrationScreen.routeName: (_) => const RegistrationScreen(),
        SyncSmsScreen.routeName: (_) => const SyncSmsScreen(),
        ResetPasswordScreen.routeName: (_) => const ResetPasswordScreen(),
      },
    );
  }
}
