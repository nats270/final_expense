import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signup/Screens/expense_list_page.dart';
import 'package:signup/Screens/monthwise_transaction_page.dart';
import 'package:signup/utils/txn_database_helper.dart';
import 'package:signup/widgets/navigation_drawer.dart';

import '../constants.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home-screen";

  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Expense Tracker")),
      drawer: const NavigationDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'ADD YOUR EXPENSES',
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                textStyle: const TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Image.asset("assets/images/img.png", width: size.width * 0.8),
            ),
          ),
          menuItem(
            Icons.shopping_cart,
            'All Expenses',
            () => Navigator.of(context).pushNamed(ExpenseListPage.routeName),
          ),
          menuItem(
            Icons.money,
            "SMS Transactions",
            () => Navigator.of(context).pushNamed(MonthWiseTransactionPage.routeName),
          ),
          menuItem(
            Icons.refresh,
            "Sync Data",
            () async {
              await TransactionDatabaseHelper.syncFirebaseRecords();
              await ExpenseDatabaseHelper.syncFirebaseRecords();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text("Sync Complete")));
            },
          ),
        ],
      ),
    );
  }

  Widget menuItem(IconData iconData, String label, Function onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60,
        color: kPrimaryLightColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: kPrimaryColor,
              child: Container(
                alignment: Alignment.center,
                child: Icon(iconData, color: kPrimaryLightColor),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.raleway(textStyle: const TextStyle(color: kPrimaryColor)),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
