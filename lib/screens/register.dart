import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessgoal/screens/login.dart';
import 'package:fitnessgoal/components/my_button.dart';
import 'package:fitnessgoal/components/my_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  bool _isLoading = false;

  Future<String?> _uploadImage() async {
    if (_image != null) {
      try {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        String fileName = 'profile_$userId.jpg';

        // Upload image to Firebase Storage
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(fileName)
            .putFile(_image!);

        // Get download URL
        String downloadURL = await snapshot.ref.getDownloadURL();
        return downloadURL;
      } catch (e) {
        print('Error uploading image: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (passwordController.text == confirmPasswordController.text) {
        // Upload image to storage and get URL
        String? imageURL = await _uploadImage();

        // Create user with email and password
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text,
        );

        // Add profile image URL to user profile
        if (imageURL != null) {
          await FirebaseAuth.instance.currentUser!.updateProfile(photoURL: imageURL);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(
              onTap: () {
                // Navigate to login screen
              },
            ),
          ),
        );
      } else {
        _showErrorMessage("Passwords don't match!");
      }
    } catch (e) {
      _showErrorMessage("Registration failed. Please try again.");
      print("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                GestureDetector(
                  onTap: _getImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[400],
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null ? Icon(Icons.person, size: 50) : null,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Tap to select profile image',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Create an account',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 25),
                MyTextField(
                  controller: usernameController,
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
                MyTextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  prefixIcon: Icons.password,
                  lableText: 'Confirm Password',
                ),
                SizedBox(height: 25),
                _isLoading
                    ? CircularProgressIndicator()
                    : MyButton(
                        onTap: _signUp,
                        text: 'Sign Up',
                      ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        ' Login Now',
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
      ),
    );
  }
}
