import 'dart:io';

import 'package:fitnessgoal/auth/change_password.dart';
import 'package:fitnessgoal/auth/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _currentUser;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        // You can upload the _imageFile to Firebase Storage or display it directly
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Center(
            child: GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: CircleAvatar(
                radius: 72,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : _currentUser?.photoURL != null
                        ? NetworkImage(_currentUser!.photoURL!)
                        : AssetImage('assets/default_profile_image.png')
                            as ImageProvider,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            _currentUser?.email ?? 'No email found',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700], fontSize: 16),
          ),
          SizedBox(height: 24),
          ListTile(
            title: Text('Edit Profile'),
            leading: Icon(Icons.edit),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => EditProfilePage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Change Password'),
            leading: Icon(Icons.lock),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (builder) => ChangePasswordPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
