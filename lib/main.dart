import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signup/Screens/expense_add_page.dart';
import 'package:signup/Screens/expense_analysis_report_screen.dart';
import 'package:signup/Screens/expense_list_page.dart';
import 'package:signup/Screens/home_screen.dart';
import 'package:signup/Screens/login_screen.dart';
import 'package:signup/Screens/monthwise_transaction_page.dart';
import 'package:signup/Screens/registration_screen.dart';
import 'package:signup/Screens/reset_password_screen.dart';
import 'package:signup/Screens/sms_analysis_report_screen.dart';
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
        appBarTheme: const AppBarTheme(
          color: kPrimaryLightColor,
          iconTheme: IconThemeData(color: kPrimaryColor),
          actionsIconTheme: IconThemeData(color: kPrimaryColor),
          titleTextStyle: TextStyle(color: kPrimaryColor, fontSize: 20),
          titleSpacing: 5,
          elevation: 1,
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: kPrimaryColor,
        ),
        scaffoldBackgroundColor: kPrimaryLightColor,
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        MonthWiseTransactionPage.routeName: (_) => const MonthWiseTransactionPage(),
        ExpenseAddPage.routeName: (_) => const ExpenseAddPage(),
        RegistrationScreen.routeName: (_) => const RegistrationScreen(),
        SyncSmsScreen.routeName: (_) => const SyncSmsScreen(),
        ResetPasswordScreen.routeName: (_) => const ResetPasswordScreen(),
        ExpenseListPage.routeName: (_) => const ExpenseListPage(),
        ExpenseAnalysisReportScreen.routeName: (_) => const ExpenseAnalysisReportScreen(),
        SMSAnalysisReportScreen.routeName: (_) => const SMSAnalysisReportScreen(),
      },
    );
  }
}
