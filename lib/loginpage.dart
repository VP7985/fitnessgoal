import 'package:fitnessgoal/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(label: Text('Email')),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                  onPressed: () async {
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();

                    try {
                      UserCredential userCredential =
                          await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    } catch (e) {
                      print('Login error: $e');
                    }
                  },
                  child: Text('Login'))
            ],
          ),
        ),
      ),
    );
  }
}
