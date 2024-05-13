import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessgoal/components/my_button.dart';
import 'package:fitnessgoal/components/my_textfield.dart';
import 'package:fitnessgoal/screens/forgetpassword.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  // GoogleSignInAccount? _currentUser;

  // @override
  // void initState() {
  //   _googleSignIn.onCurrentUserChanged.listen((account) {
  //     setState(() {
  //       _currentUser = account;
  //     });
  //   });
  //   _googleSignIn.signInSilently();
  //   super.initState();
  // }

  // Widget  _buildWidget() {
  //   GoogleSignInAccount? user = _currentUser;
  //   if (user != null) {
  //     return Padding(
  //       padding: const EdgeInsets.fromLTRB(2, 12, 2, 12),
  //       child: Column(
  //         children: [
  //           ListTile(
  //             leading: GoogleUserCircleAvatar(identity: user),
  //             title: Text(
  //               user.displayName ?? '',
  //               style: TextStyle(fontSize: 22),
  //             ),
  //             subtitle: Text(user.email, style: TextStyle(fontSize: 22)),
  //           ),
  //           const SizedBox(
  //             height: 20,
  //           ),
  //           const Text(
  //             'Signed in successfully',
  //             style: TextStyle(fontSize: 20),
  //           ),
  //           const SizedBox(
  //             height: 10,
  //           ),
  //           ElevatedButton(onPressed: signOut, child: const Text('Sign out'))
  //         ],
  //       ),
  //     );
  //   } else {
  //     return Padding(
  //       padding: const EdgeInsets.all(12.0),
  //       child: Column(
  //         children: [
  //           const SizedBox(
  //             height: 20,
  //           ),
  //           const Text(
  //             'You are not signed in',
  //             style: TextStyle(fontSize: 30),
  //           ),
  //           const SizedBox(
  //             height: 10,
  //           ),
  //           ElevatedButton(
  //               onPressed: signIn,
  //               child: const Padding(
  //                 padding: EdgeInsets.all(8.0),
  //                 child: Text('Sign in', style: TextStyle(fontSize: 30)),
  //               )),
  //         ],
  //       ),
  //     );
  //   }
  // }

  // void signOut() {
  //   _googleSignIn.disconnect();
  // }

  // Future<void> signIn() async {
  //   try {
  //     await _googleSignIn.signIn();
  //   } catch (e) {
  //     print('Error signing in $e');
  //   }
  // }
googleLogin() async {
    print("googleLogin method Called");
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var reslut = await _googleSignIn.signIn();
      if (reslut == null) {
        return;
      }

      final userData = await reslut.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      var finalResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("Result $reslut");
      print(reslut.displayName);
      print(reslut.email);
      print(reslut.photoUrl);
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  }


  void forgetpass(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotPasswordPage(),
      ),
    );
  }

  bool isLoading = false;

  Future<void> signInUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Sign-in successful, handle navigation or further actions here
      } else {
        _showErrorMessage("Please enter valid email and password.");
      }
    } catch (e) {
      _showErrorMessage("Sign-in failed. Please try again.");
      print("Error: $e");
    }

    setState(() {
      isLoading = false;
    });
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
                    SizedBox(height: 30),
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
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => forgetpass(context),
                            child: Text(
                              'Forget password',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    MyButton(
                      onTap: signInUser,
                      text: "Sign In",
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              googleLogin();
                            },
                            child: Text("Sign up with Google"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create an account',
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
            if (isLoading)
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
}