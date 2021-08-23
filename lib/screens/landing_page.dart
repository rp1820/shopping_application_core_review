import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopping_application_qstp/constants.dart';
import 'package:shopping_application_qstp/screens/home_page.dart';
import 'package:shopping_application_qstp/screens/login_page.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error :${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, streamSnapshot) {
                  if (streamSnapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text('Error-->${streamSnapshot.error}'),
                      ),
                    );
                  }
                  //if block to check the current state of the user i.e., logged in or logged out
                  if (streamSnapshot.connectionState ==
                      ConnectionState.active) {
                    User? _user = streamSnapshot.data as User?;
                    if (_user == null) {
                      return LoginPage(); //if user is not logged into the app send user to log in page for the same
                    } else {
                      return HomePage(); //implying user is logged in so goes to home page for further functionality
                    }
                  }

                  return Scaffold(
                    body: Center(
                      child: Text(
                        'Checking Authentication....',
                        style: Constants.standardHeading,
                      ),
                    ),
                  );
                });
          }

          return Scaffold(
            body: Center(
              child: Text('Loading'),
            ),
          );
        });
  }
}
