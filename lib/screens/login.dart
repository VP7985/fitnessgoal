import 'package:fitnessgoal/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fitnessgoal/screens/homepage.dart';
import 'package:fitnessgoal/screens/forgetpassword.dart';
import 'package:fitnessgoal/components/my_button.dart';
import 'package:fitnessgoal/components/my_textfield.dart';
import 'package:fitnessgoal/components/google_signin_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  final Function() onTap;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _signInUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        _navigateToHomePage();
      } else {
        _showErrorMessage("Please enter valid email and password.");
      }
    } catch (e) {
      _showErrorMessage("Login failed. Please try again.");
      print("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _googleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      GoogleSignIn _googleSignIn = GoogleSignIn();
      
      // Sign out from the Google account if already signed in
      await _googleSignIn.signOut();
      
      var result = await _googleSignIn.signIn();
      if (result == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth = await result.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      _navigateToHomePage();
    } catch (error) {
      print("Error during Google sign-in: $error");
      _showErrorMessage("Google sign-in failed. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          onSignOut: () {},
          userName: '$User',
          onProfile: () {
            ProfilePage();
          },
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),
                    Icon(
                      Icons.account_circle,
                      size: 100,
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 25),
                    MyTextField(
                      controller: emailController,
                      obscureText: false,
                      prefixIcon: Icons.person,
                      lableText: 'Username',
                    ),
                    SizedBox(height: 10),
                    MyTextField(
                      controller: passwordController,
                      obscureText: true,
                      prefixIcon: Icons.lock,
                      lableText: 'Password',
                    ),
                    SizedBox(height: 25),
                    _isLoading
                        ? SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: null,
                              child: Text("Signing In..."),
                            ),
                          )
                        : MyButton(
                            onTap: _signInUser,
                            text: 'Sign In',
                          ),
                    SizedBox(height: 20),
                    MyGoogleButton(
                      onPressed: _googleLogin,
                      text: 'Sign In with Google',
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        _forgetPassword(context);
                      },
                      child: Text(
                        'Forget password',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            ' Register Now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _forgetPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotPasswordPage(),
      ),
    );
  }
}
