import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signup/models/user_model.dart';

import '../constants.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const routeName = "/reset-password-screen";
  const ResetPasswordScreen({Key key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _auth = FirebaseAuth.instance;

  String errorMessage;

  final _formKey = GlobalKey<FormState>();

  final emailEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty) {
          return ("Please Enter Your Email");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Email ID',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final resetButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: kPrimaryColor,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width * 0.4,
        child: Text(
          'RESET',
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: kPrimaryLightColor,
              //fontWeight: FontWeight.w800,
              //fontStyle: FontStyle.italic,
              fontSize: 20,
            ),
          ),
          //style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        onPressed: () {
          resetPass(emailEditingController.text);
          //signIn(emailController.text, passwordController.text);
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.deepPurple,
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
                    const SizedBox(height: 20),
                    SvgPicture.asset(
                      "assets/icons/signup.svg",
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                    const SizedBox(height: 5),
                    emailField,
                    const SizedBox(height: 5),
                    // passwordField,
                    const SizedBox(height: 5),
                    // confirmpasswordField,
                    const SizedBox(height: 5),
                    resetButton,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //children: ,
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

  void resetPass(String email) async {
    if (_formKey.currentState.validate()) {
      try {
        await _auth.sendPasswordResetEmail(email: email).then((value) => {postDetailsToFirestore()}).catchError((e) {
          Fluttertoast.showToast(msg: e.message);
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

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user.email;
    userModel.uid = user.uid;
    //userModel.firstName = firstNameEdittingController.text;
    //userModel.lastName = lastNameEdittingController.text;

    await firebaseFirestore.collection("users").doc(user.uid).set(userModel.toMap());
    Fluttertoast.showToast(msg: "Password reset successful :) ");

    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }
}
