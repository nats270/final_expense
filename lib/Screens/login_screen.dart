import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signup/Screens/home_screen.dart';
import 'package:signup/Screens/sync_sms_screen.dart';
import 'package:signup/utils/auth_database_helper.dart';

import '../constants.dart';
import 'registration_screen.dart';
import 'reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login-screen";
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      if (FirebaseAuthService.currentUser != null) {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty) {
          return ("Please enter email");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: kPrimaryColor,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width * 0.4,
        child: Text(
          'LOGIN',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: kPrimaryLightColor,
              //fontWeight: FontWeight.w800,
              //fontStyle: FontStyle.italic,
              fontSize: 20,
            ),
          ),
        ),
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
      ),
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "EXPENSE TRACKER",
                      style: GoogleFonts.raleway(
                        textStyle: const TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w800,
                          //fontStyle: FontStyle.italic,
                          fontSize: 30,
                        ),
                      ),
                      //style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w800, fontSize: 26),
                    ),
                    const SizedBox(height: 20),
                    SvgPicture.asset(
                      "assets/icons/login.svg",
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                    const SizedBox(height: 25),
                    emailField,
                    const SizedBox(height: 25),
                    passwordField,
                    const SizedBox(height: 25),
                    loginButton,
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed(ResetPasswordScreen.routeName);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?", style: GoogleFonts.raleway(textStyle: const TextStyle(color: Colors.black))),
                        GestureDetector(
                          child: Text(
                            "Sign UP",
                            style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed(RegistrationScreen.routeName);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState.validate()) {
      try {
        await FirebaseAuthService.signIn(email, password).then((uid) => {
              Fluttertoast.showToast(msg: "Login Successful"),
              Navigator.of(context).pushReplacementNamed(SyncSmsScreen.routeName),
            });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage);
        print(error.code);
      }
    }
  }
}
