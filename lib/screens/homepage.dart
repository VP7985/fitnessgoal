import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fitnessgoal/components/drawer.dart';
import 'package:fitnessgoal/screens/profile_page.dart';
import 'package:fitnessgoal/screens/habit_tracking.dart';

class HomePage extends StatefulWidget {
  final String userName; // New parameter for user name
  final Function()? onProfile;
  final void Function()? onSignOut;

  void habittracker(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => habiittracker(),
      ),
    );
  }

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
        appBar: AppBar(),
        drawer: DrawerPage(
          onProfile: goToProfilePage,
          onSignOut: signUserOut,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to Home Page ',
                style: TextStyle(fontSize: 24),
              ),
              const Text(
                'To Add new Habit Push Add Button',
              ),
              Text(
                '',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.habittracker(context);
          },
          child: Icon(Icons.add),
        ));
  }
}
