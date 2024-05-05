import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessgoal/auth/login_reg.dart';
import 'package:flutter/material.dart';

/*
class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              // User is logged in
              return Container(
                child: Center(
                  child: Text('User is logged in!'),
                ),
              );
            } else {
              // User is not logged in, show login/register screens
              return LoginOrReg();
            }
          }
        },
      ),
    );
  }
}
*/