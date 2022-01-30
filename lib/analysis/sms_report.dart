import 'package:flutter/material.dart';

import '../constants.dart';

class SmsReport extends StatefulWidget {
  const SmsReport({Key key}) : super(key: key);

  // const AnalysisReport();

  @override
  _SmsReportState createState() => _SmsReportState();
}

class _SmsReportState extends State<SmsReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'SMS REPORT',
          style: TextStyle(color: kPrimaryColor),
        ),
      ),
    );
  }
}
