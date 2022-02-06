import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:signup/components/rounded_button.dart';
import 'package:signup/utils/txn_database_helper.dart';

import '../constants.dart';
import 'home_screen.dart';

class SyncSmsScreen extends StatefulWidget {
  static const routeName = "/sync-sms-screen";

  const SyncSmsScreen({Key ? key}) : super(key: key);

  @override
  State<SyncSmsScreen> createState() => _SyncSmsScreenState();
}

class _SyncSmsScreenState extends State<SyncSmsScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Center(
          //   child: Image.asset(
          //     "assets/images/main_top.png",
          //     width: size.width * 0.3,
          //   ),
          // ),
          // Positioned(
          //   child: Image.asset("assets/images/main_bottom.png"),
          //   width: size.width * 0.2,
          // ),
          Opacity(
            opacity: loading ? 0.5 : 1.0,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'EXPENSE TRACKER',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                  SizedBox(height: size.height * 0.03),
                  SvgPicture.asset(
                    "assets/icons/chat.svg",
                    height: size.height * 0.45,
                  ),
                  SizedBox(height: size.height * 0.03),
                  RoundedButton(
                    text: "Sync Data",
                    color: kPrimaryColor,
                    textColor: kPrimaryLightColor,
                    press: () async {
                      setState(() {
                        loading = true;
                      });
                      await TransactionDatabaseHelper.syncFirebaseRecords();
                      await ExpenseDatabaseHelper.syncFirebaseRecords();
                      setState(() {
                        loading = false;
                      });
                      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
          if (loading)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [CircularProgressIndicator(), Text("Please wait while its being done!")],
            ),
        ],
      ),
    );
  }
}
