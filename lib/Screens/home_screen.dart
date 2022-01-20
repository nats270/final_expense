import 'package:flutter/material.dart';
import 'package:signup/constants.dart';
import 'package:signup/refresh.dart';
import 'package:signup/widgets/list.dart';
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.deepPurple,
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WelcomeHomeScreen()));
          },),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // Padding(
              //   padding: EdgeInsets.only(top: 10),
              //   child: SizedBox(height: 120),
              //   //child: Image.asset("assets/images/img.png",
              //   // width: size.width * 0.5,),
              // ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.asset(
                  "assets/images/img.png",
                  width: size.width * 0.8,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'ADD EXPENSES or REFRESH TO TRACK',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(textStyle:TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 24,
                      color: Colors.deepPurple,
                    ),
                  ))),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyAppp()));
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: Text('ADD', style: GoogleFonts.raleway(textStyle: TextStyle(color: Colors.white))),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ListPage()));
                      //Navigator.of(context).push(MaterialPageRoute(builder: (_) => PieChartPage()));
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                    ),
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: Text('REFRESH', style: GoogleFonts.raleway(textStyle:TextStyle(color: Colors.white))),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Refresh()));
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                    ),
                    icon: const Icon(Icons.money, color: Colors.white),
                    label: Text('SMS', style: GoogleFonts.raleway(textStyle:TextStyle(color: Colors.white))),
                  ),
                  const SizedBox(width: 10),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
