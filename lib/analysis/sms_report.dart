import 'package:expense_app_new/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          title: Text('SMS REPORT', style: TextStyle(color: kPrimaryColor),),
        ),
        bottomNavigationBar: BottomAppBar(
          child: IconButton(icon: Icon(Icons.arrow_back,color: kPrimaryColor,),
            onPressed: (){
              Navigator.of(context).pop();
            },
            color: kPrimaryColor,
          ),
        ));
  }
}
