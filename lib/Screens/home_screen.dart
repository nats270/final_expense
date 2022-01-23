import 'package:expense_app_new/analysis/analysis_report.dart';
import 'package:expense_app_new/analysis/sms_report.dart';
import 'package:expense_app_new/newScreens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expense_app_new/constants.dart';
import 'package:expense_app_new/refresh.dart';
import 'package:expense_app_new/widgets/list.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Screens/option_page.dart';
import 'WelcomeHome/welcome_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        iconTheme: const IconThemeData(color: kPrimaryColor),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.deepPurple,
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WelcomeHomeScreen()));
            },),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
           //height: 20,
                  color: kPrimaryLightColor,
                  child: const ListTile(
                    leading:
                    IconButton(icon:Icon(Icons.menu,color: kPrimaryColor,)),
                  ),
                  //child: Text('Analysis')
             ),
            Container(
             // height: 100,
                color: kPrimaryLightColor,
                //child: Text('Analysis')
              ),
            Container(
              height: 270,
              color: kPrimaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Container(height: 30,),
                  Row(
                    children: [
                      Card(
                        color:kPrimaryLightColor,
                        child: IconButton(
                          icon:const Icon(Icons.business,color: kPrimaryColor,),
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnalysisReport()));
                          },
                        ),
                    ),
                      const Text('Expense Analysis Report',style: TextStyle(color: kPrimaryLightColor),)
                    ],
                  ),
                  Row(
                    children: [
                      Card(
                        color:kPrimaryLightColor,
                        child: IconButton(icon:const Icon(Icons.sms,color: kPrimaryColor,),
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SmsReport()));

                          },
                        )
                    ),
                      const Text('SMS Analysis Report',style: TextStyle(color: kPrimaryLightColor),)
                    ],
                  ),
                  Row(
                    children: [
                      Card(
                        color:kPrimaryLightColor,
                        child: IconButton(
                          icon:const Icon(Icons.logout,color: kPrimaryColor,),
                          onPressed: (){
                            logout(context);
                          },
                        ),
                      ),
                      const Text('LogOut',style: TextStyle(color: kPrimaryLightColor),)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                      'ADD YOUR EXPENSES',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(textStyle:TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      ))),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.asset(
                  "assets/images/img.png",
                  width: size.width * 0.8,
                ),
              ),

              //const SizedBox(height: 100),
              Container(
                height: 60,
                color: kPrimaryLightColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyAppp()));
                        },
                        // style: ButtonStyle(
                        //   shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        //   backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                        // ),
                        icon: const Icon(Icons.add, color: kPrimaryLightColor),
                       // label: Text('ADD',style: GoogleFonts.raleway(textStyle: TextStyle(color: Colors.white))),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text('Add Expenses' , style: GoogleFonts.raleway(textStyle: TextStyle(color:kPrimaryColor)),),
                   const SizedBox(width: 10),
                  ],
                ),
              ),

              Container(
                height: 60,
                color: kPrimaryLightColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    // ElevatedButton.icon(
                    //   onPressed: () {
                    //     Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyAppp()));
                    //   },
                    //   style: ButtonStyle(
                    //     shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    //     backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                    //   ),
                    //   icon: const Icon(Icons.add, color: Colors.white),
                    //   label: Text('ADD',style: GoogleFonts.raleway(textStyle: TextStyle(color: Colors.white))),
                    // ),
                    CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ListPage()));
                        },
                        // style: ButtonStyle(
                        //   shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        //   backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                        // ),
                        icon: const Icon(Icons.refresh, color: kPrimaryLightColor),
                        // label: Text('ADD',style: GoogleFonts.raleway(textStyle: TextStyle(color: Colors.white))),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text('Expenses List' , style: GoogleFonts.raleway(textStyle: TextStyle(color:kPrimaryColor)),),
                    // ElevatedButton.icon(
                    //   onPressed: () {
                    //     Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ListPage()));
                    //     //Navigator.of(context).push(MaterialPageRoute(builder: (_) => PieChartPage()));
                    //   },
                    //   style: ButtonStyle(
                    //     shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    //     backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                    //   ),
                    //   icon: const Icon(Icons.refresh, color: Colors.white),
                    //   label: Text('EXPENSE LIST', style: GoogleFonts.raleway(textStyle:TextStyle(color: Colors.white))),
                    // ),
                    // ElevatedButton.icon(
                    //   onPressed: () {
                    //     Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Refresh()));
                    //   },
                    //   style: ButtonStyle(
                    //     shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    //     backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                    //   ),
                    //   icon: const Icon(Icons.money, color: Colors.white),
                    //   label: Text('SMS', style: GoogleFonts.raleway(textStyle:TextStyle(color: Colors.white))),
                    // ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              Container(
                height: 60,
                color: kPrimaryLightColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Refresh()));
                        },
                        icon: const Icon(Icons.money, color: kPrimaryLightColor),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text('SMS Transactions' , style: GoogleFonts.raleway(textStyle: TextStyle(color:kPrimaryColor)),),
                    // ElevatedButton.icon(
                    //   onPressed: () {
                    //     Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Refresh()));
                    //   },
                    //   style: ButtonStyle(
                    //     shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    //     backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                    //   ),
                    //   icon: const Icon(Icons.money, color: Colors.white),
                    //   label: Text('SMS', style: GoogleFonts.raleway(textStyle:TextStyle(color: Colors.white))),
                    // ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const NewLoginScreen()));
}
}
