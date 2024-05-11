import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fitnessgoal/components/drawer.dart';
import 'package:fitnessgoal/screens/profile_page.dart';

class HomePage extends StatefulWidget {
  final String userName; // New parameter for user name
  final Function()? onProfile;
  final void Function()? onSignOut;

  const HomePage({
    Key? key,
    required this.userName,
    required this.onProfile,
    required this.onSignOut,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signUserOut() async {
    FirebaseAuth.instance.signOut();
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(), // Pass userName to ProfilePage
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar()  ,
      drawer: DrawerPage(
        onProfile: () => goToProfilePage(),
        onSignOut: () => signUserOut(),
      ),
      body: Center(
        child: Text(
          'Welcome to Home Page ', 
           style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
