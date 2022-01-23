import 'package:expense_app_new/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalysisReport extends StatefulWidget {
  const AnalysisReport({Key key}) : super(key: key);

 // const AnalysisReport();

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
        title: Text('REPORT', style: TextStyle(color: kPrimaryColor),),
      ),
      body: Container(

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
