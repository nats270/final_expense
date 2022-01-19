import 'package:flutter/material.dart';
import 'package:signup/charts/pie_chart.dart';

import 'monthwise_transaction_page.dart';

class BankListItem extends StatelessWidget {
  final String bnkName;

  const BankListItem(this.bnkName, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        debugPrint("hello");
        Navigator.push(context, MaterialPageRoute(builder: (context) => MonthWiseTransactionPage(bnkName)));
      },
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PieChart(bnkName))
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.deepPurple,
                width: 3.0,
              ),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Center(
              child: Text(
                bnkName,
                style: TextStyle(fontSize: 20.0, color: Colors.deepPurple),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
