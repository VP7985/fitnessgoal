import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitnessgoal/auth/login_reg.dart';
import 'package:fitnessgoal/screens/homepage.dart';
import 'package:fitnessgoal/screens/profile_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget { 
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize Firebase asynchronously
      future: Firebase.initializeApp(),
      builder: (context, AsyncSnapshot<FirebaseApp> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error initializing Firebase'),
            ),
          );
        }

        // Once Firebase is initialized, listen to auth state changes
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot<User?> authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final user = authSnapshot.data;

            if (user != null) {
              // User is authenticated, show home page
              return HomePage(
                onProfile: () {
                  // Navigate to profile page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage (),
                    ),
                  );
                },
                onSignOut: () async {
                  // Sign out the user
                  await FirebaseAuth.instance.signOut();
                }, userName: '',
              );
            } else {
              // User is not authenticated, show login or registration page
              return LoginOrReg();
            }
          },
        );
      },
    );
  }
}
