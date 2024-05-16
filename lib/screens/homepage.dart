import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitnessgoal/database/database_healper.dart';
import 'package:fitnessgoal/models/habit.dart';
import 'package:fitnessgoal/screens/add_habit.dart';
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
  late Future<List<Habit>> _habitList;
  @override
  void initState() {
    super.initState();
    _habitList = DatabaseHelper().getHabits();
  }

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
      body: FutureBuilder<List<Habit>>(
        future: _habitList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No habits found.'));
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final habit = snapshot.data![index];
                return ListTile(
                  leading:
                      Icon(Icons.check_circle_outline, color: Colors.green),
                  title: Text(habit.title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      '${habit.description}\nDate: ${habit.date}\nTime: ${habit.time}'),
                  trailing: Icon(Icons.more_vert),
                  onTap: () {
                    // Handle item tap
                  },
                );
              },
              separatorBuilder: (context, index) => Divider(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.small(
      floatingActionButton: FloatingActionButton.small(
        foregroundColor: Colors.blueGrey,
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (builder) => AddHabitPage()));
          Navigator.push(
              context, MaterialPageRoute(builder: (builder) => AddHabitPage()));
        },
        child: const Icon(Icons.add),
        child: const Icon(Icons.add),
      ),
    );
  }
}
