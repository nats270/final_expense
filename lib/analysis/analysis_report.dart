import 'package:flutter/material.dart';

import '../constants.dart';

class AnalysisReport extends StatefulWidget {
  const AnalysisReport({Key key}) : super(key: key);

  @override
  _AnalysisReportState createState() => _AnalysisReportState();
}

class _AnalysisReportState extends State<AnalysisReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('REPORT', style: TextStyle(color: kPrimaryColor)),
      ),
      body: Container(),
    );
  }
}
