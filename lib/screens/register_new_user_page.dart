import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_application_qstp/widgets/button_1.dart';
import 'package:shopping_application_qstp/widgets/custom_input_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants.dart';

class SecondPageRoute extends CupertinoPageRoute {
  SecondPageRoute()
      : super(builder: (BuildContext context) => new RegisterPage());

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new RegisterPage());
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Future<void> _alertDialogBuilder(String error) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Container(
              child: Text(error),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'))
            ],
          );
        });
  }

//Create a new user account

  Future<String?> _createAccount() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _registerEmail, password: _registerPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

//Function to check the string returned by Future Create Account to either register the user or display error message

  void accountRegistration() async {
    //causing the circular loader to appear
    setState(() {
      isRegisterFormLoading = true;
    });
    //running the account creating method
    String? _registrationFeedback = await _createAccount();
    if (_registrationFeedback != null) {
      _alertDialogBuilder(_registrationFeedback);

      //causing the circular loader to disappear post account registration/error display
      setState(() {
        isRegisterFormLoading = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  bool isRegisterFormLoading = false;

  //declaration for user email and password

  String _registerEmail = "";
  String _registerPassword = "";

  //focus node for input fields

  FocusNode? passwordFocusNode;

  @override
  void initState() {
    passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    passwordFocusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Text(
                  'Create New Account',
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
                ),
              ),
              Column(
                children: [
                  //EMAIL FIELD
                  CustomInputFields(
                    hint: 'Email..',
                    onChanged: (value) {
                      _registerEmail = value;
                    },
                    onSubmitted: (value) {
                      passwordFocusNode!.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  //PASSWORD FIELD
                  CustomInputFields(
                    hint: 'Password..',
                    onChanged: (value) {
                      _registerPassword = value;
                    },
                    isPasswordField: true,
                    focusNode: passwordFocusNode,
                  ),
                  CustomButton(
                    text: 'REGISTER',
                    onPressed: () {
                      accountRegistration();
                    },
                    isLoading: isRegisterFormLoading,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: CustomButton(
                  text: 'Back to Login',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  outlineBtn: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
