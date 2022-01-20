import 'package:flutter/material.dart';
import 'package:signup/Screens/WelcomeHome/components/body.dart';

class WelcomeHomeScreen extends StatelessWidget {
  const WelcomeHomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Body(),
    );
  }
}
