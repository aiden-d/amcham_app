import 'package:amcham_app_v2/screens/verify_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amcham_app_v2/constants.dart';
import 'package:amcham_app_v2/components/rounded_button.dart';
import 'package:amcham_app_v2/components/rounded_text_field.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:amcham_app_v2/components/amcham_logo.dart';
import 'package:amcham_app_v2/components/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> _alertDialogBuilder(String title, String info) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title != null ? title : "Error"),
            content: Container(
              child: Text(info),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Close Dialog"))
            ],
          );
        });
  }

  Future<String> _loginToAccount() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  //submit form
  void _submitForm() async {
    setState(() {
      isLoading = true;
    });
    String _createAccountFeedback = await _loginToAccount();

    if (_createAccountFeedback != null) {
      _alertDialogBuilder('Error', _createAccountFeedback);
    } else if (FirebaseAuth.instance.currentUser.emailVerified == false) {
      Navigator.push(
          (context), MaterialPageRoute(builder: (context) => VerifyScreen()));
    } else {
      Navigator.pop(context);
    }
    setState(() {
      isLoading = false;
    });
  }

  bool isLoading = false;

  String _email = "";
  String _password = "";

  FocusNode _lastNameFocusNode;
  FocusNode _companyFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;
  FocusNode _passwordConfFocusNode;
  @override
  void initState() {
    _lastNameFocusNode = FocusNode();
    _companyFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _passwordConfFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _lastNameFocusNode.dispose();
    _companyFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("lib/images/TreeBackground.png"),
              fit: BoxFit.cover)),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  Stack(
                    children: [
                      IconButton(
                        padding: EdgeInsets.all(5),
                        iconSize: 50,
                        alignment: Alignment.topLeft,
                        onPressed: () {
                          print("pressed");
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          CupertinoIcons.arrow_left,
                          color: Colors.white,
                        ),
                      ),
                      Center(child: Hero(tag: 'logo', child: AmchamLogo())),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RoundedTextField(
                    width: 420,
                    height: 60,
                    radius: 9,
                    hintText: 'Email',
                    onChanged: (value) {
                      _email = value;
                    },
                    focusNode: _emailFocusNode,
                    onSubmitted: (value) {
                      _passwordFocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  RoundedTextField(
                    width: 420,
                    height: 60,
                    radius: 9,
                    hintText: 'Password',
                    onChanged: (value) {
                      _password = value;
                    },
                    focusNode: _passwordFocusNode,
                    onSubmitted: (value) {
                      _submitForm();
                    },
                    isPasswordField: true,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RoundedButton(
                    onPressed: () {
                      //_alertDialogBuilder();
                      _submitForm();
                    },
                    isLoading: isLoading,
                    title: 'Login',
                    textStyle: Constants.blueText,
                    width: 400,
                    height: 60,
                    radius: 15,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ForgotPassword(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
