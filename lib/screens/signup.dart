import 'package:blog_minimal/screens/home_page.dart';
import 'package:blog_minimal/screens/signin.dart';
import 'package:blog_minimal/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  SignUp({Key key}) : super(key: key);

  String errorMessage = "Please enter your credentials";
  //  final _user = FirebaseAuth.instance.currentUser;
  void logIn(
      {BuildContext context,
      String email,
      String password,
      isLogin,
      String username}) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        if (isLogin) {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                email: email,
                password: password,
              )
              .then(
                (value) => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                ),
              );
        } else {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ).then((value) async {
               final _user = FirebaseAuth.instance.currentUser;
               await FirebaseFirestore.instance.collection('users').doc(_user.uid).set({'username': username});

          });
        }
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "email-already-in-use":
            errorMessage = "Already have an account. Try Login";
            break;
          case "weak-password":
            errorMessage = "Please enter a strong password.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "invalid-email":
            errorMessage = "Please enter a valid email address..............";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests. Try again later.";
            break;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  // void logIn() async {
  //   await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: emailController.text.trim(),
  //       password: passowrdController.text.trim());
  // }

  final emailController = TextEditingController();
  final passowrdController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print(_user.email);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Sign Up',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: width,
                    child: Image.asset(
                      'assets/images/logo-png.png',
                      width: width * 0.5,
                      height: height * 0.3,
                    )),
                Text('UserName', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: height * 0.01),
                CustomTextField(
                  hint: 'Enter UserName',
                  controller: usernameController,
                ),
                SizedBox(height: height * 0.03),
                Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: height * 0.01),
                CustomTextField(
                  hint: 'Enter Email',
                  controller: emailController,
                ),
                SizedBox(height: height * 0.03),
                Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: height * 0.01),
                CustomTextField(
                  hint: 'Enter Password',
                  controller: passowrdController,
                ),
                SizedBox(height: height * 0.05),
                Center(
                  child: Container(
                    width: width * 0.5,
                    height: height * 0.06,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xff11586b))),
                      onPressed: () {
                        logIn(
                            context: context,
                            email: emailController.text.trim(),
                            password: passowrdController.text.trim(),
                            username: usernameController.text.trim(),
                            isLogin: false);
                      },
                      child: Text("Sign-Up"),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
                Center(
                  child: Container(
                    width: width * 0.6,
                    height: height * 0.06,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: InkWell(
                      onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignIn(
                                    logIn: logIn,
                                  ))),
                      child: Row(
                        children: [
                          Text("Already have an account? "),
                          Text(
                            "sign in",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color(0xff11586b),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
