import 'package:flutter/material.dart';
import 'package:signup/Screens/expense_analysis_report_screen.dart';
import 'package:signup/Screens/home_screen.dart';
import 'package:signup/Screens/login_screen.dart';
import 'package:signup/Screens/sms_analysis_report_screen.dart';
import 'package:signup/utils/auth_database_helper.dart';

import '../constants.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: kToolbarHeight / 2),
          Expanded(
            child: Container(
              color: kPrimaryColor,
              child: ListView(
                children: [
                  ListTile(
                    leading: const Card(
                      color: kPrimaryLightColor,
                      child: Padding(padding: EdgeInsets.all(10), child: Icon(Icons.home, color: kPrimaryColor)),
                    ),
                    title: const Text('Home', style: TextStyle(color: kPrimaryLightColor)),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Card(
                      color: kPrimaryLightColor,
                      child: Padding(padding: EdgeInsets.all(10), child: Icon(Icons.business, color: kPrimaryColor)),
                    ),
                    title: const Text('Expense Analysis Report', style: TextStyle(color: kPrimaryLightColor)),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(ExpenseAnalysisReportScreen.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Card(
                      color: kPrimaryLightColor,
                      child: Padding(padding: EdgeInsets.all(10), child: Icon(Icons.sms, color: kPrimaryColor)),
                    ),
                    title: const Text('SMS Analysis Report', style: TextStyle(color: kPrimaryLightColor)),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(SMSAnalysisReportScreen.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Card(
                      color: kPrimaryLightColor,
                      child: Padding(padding: EdgeInsets.all(10), child: Icon(Icons.logout, color: kPrimaryColor)),
                    ),
                    title: const Text('LogOut', style: TextStyle(color: kPrimaryLightColor)),
                    onTap: () {
                      logout(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuthService.logout();
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }
}
