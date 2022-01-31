import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signup/Screens/login_screen.dart';
import 'package:signup/Screens/sync_sms_screen.dart';
import 'package:signup/models/user_model.dart';
import 'package:signup/utils/auth_database_helper.dart';

import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = "/registration-screen";

  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String errorMessage;

  final _formKey = GlobalKey<FormState>();

  final firstNameEditingController = TextEditingController();
  final lastNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.text,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value.isEmpty) {
          return ("First Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid name(Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'First Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value.isEmpty) {
          return ("Last Name cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        lastNameEditingController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Last Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty) {
          return ("Please Enter Your Email");
        }
        // reg expression for email validation
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      //keyboardType: TextInputType.text,
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
        passwordEditingController.text = value;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    final confirmpasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingController.text != passwordEditingController.text) {
          return "Password don't match";
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: 'Confirm Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: kPrimaryColor,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width * 0.4,
        child: const Text(
          'SIGN UP',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        onPressed: () {
          signup(emailEditingController.text, passwordEditingController.text);
        },
      ),
    );

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up"),
        ),
        body: Center(
          child: SingleChildScrollView(
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
                    firstNameField,
                    const SizedBox(height: 5),
                    lastNameField,
                    const SizedBox(height: 5),
                    emailField,
                    const SizedBox(height: 5),
                    passwordField,
                    const SizedBox(height: 5),
                    confirmpasswordField,
                    const SizedBox(height: 5),
                    signUpButton,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [],
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

  void signup(String email, String password) async {
    if (_formKey.currentState.validate()) {
      try {
        await FirebaseAuthService.createUser(email, password).then((value) => {postDetailsToFirestore()}).catchError((e) {
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

  Future postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User user = FirebaseAuthService.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.lastName = lastNameEditingController.text;

    await firebaseFirestore.collection("users").doc(user.uid).set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.of(context).pushReplacementNamed(SyncSmsScreen.routeName);
  }
}
