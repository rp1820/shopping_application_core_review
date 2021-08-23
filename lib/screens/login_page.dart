import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_application_qstp/constants.dart';
import 'package:shopping_application_qstp/screens/register_new_user_page.dart';
import 'package:shopping_application_qstp/widgets/button_1.dart';
import 'package:shopping_application_qstp/widgets/custom_input_fields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //AlertBox
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

  Future<String?> _loginAccount() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _loginEmail, password: _loginPassword);
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

//Function to check the string returned by Future Create Account to either register the user or display error message

  void accountLogin() async {
    //causing the circular loader to appear
    setState(() {
      isLoginFormLoading = true;
    });
    //running the account creating method
    String? _signInFeedback = await _loginAccount();
    if (_signInFeedback != null) {
      _alertDialogBuilder(_signInFeedback);

      //causing the circular loader to disappear post account registration/error display
      setState(() {
        isLoginFormLoading = false;
      });
    }
  }

  bool isLoginFormLoading = false;

  //declaration for user email and password

  String _loginEmail = "";
  String _loginPassword = "";

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
                  'Welcome User',
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
                ),
              ),
              Column(
                children: [
                  CustomInputFields(
                    hint: 'Email..',
                    onChanged: (value) {
                      _loginEmail = value;
                    },
                    onSubmitted: (value) {
                      passwordFocusNode!.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  CustomInputFields(
                    hint: 'Password..',
                    isPasswordField: true,
                    onChanged: (value) {
                      _loginPassword = value;
                    },
                    focusNode: passwordFocusNode,
                  ),
                  CustomButton(
                    text: 'Login',
                    onPressed: () {
                      accountLogin();
                    },
                    isLoading: isLoginFormLoading,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: CustomButton(
                  text: 'Create New Account',
                  onPressed: () {
                    Navigator.push(context, SecondPageRoute());
                  },
                  outlineBtn: true,
                  isLoading: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
