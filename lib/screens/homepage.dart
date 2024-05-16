import 'package:fitnessgoal/database/database_healper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessgoal/components/drawer.dart';

import 'package:fitnessgoal/models/habit.dart';
import 'package:fitnessgoal/screens/add_habit.dart';
import 'package:fitnessgoal/screens/delete_habit.dart';
import 'package:fitnessgoal/screens/edit_habit.dart';
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
    _refreshHabitList();
  }

  void _refreshHabitList() {
    setState(() {
      _habitList = DatabaseHelper().getHabits();
    });
  }

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    if (widget.onSignOut != null) {
      widget.onSignOut!();
    }
  }

  void goToProfilePage() {
    Navigator.pop(context);
    if (widget.onProfile != null) {
      widget.onProfile!();
    }
  }

  void _handleHabitTap(Habit habit) {
    // Implement your desired behavior when tapping a habit item
    print('Tapped on habit: ${habit.title}');
    // Example: Navigate to a detail screen or perform other actions
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
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
            // Sort habits by title in ascending order
            snapshot.data!.sort((a, b) => a.title.compareTo(b.title));
            return RefreshIndicator(
              onRefresh: () async {
                _refreshHabitList();
              },
              child: ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final habit = snapshot.data![index];
                  return ListTile(
                    leading: Icon(Icons.check_circle_outline, color: Colors.green),
                    title: Text(
                      habit.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${habit.description}\nDate: ${habit.date}\nTime: ${habit.time}',
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                      onSelected: (value) async {
                        if (value == 'edit') {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditHabitPage(habit: habit),
                            ),
                          );
                          _refreshHabitList(); // Refresh after edit
                        } else if (value == 'delete') {
                          showDialog(
                            context: context,
                            builder: (context) => DeleteHabitPage(habit: habit),
                          ).then((_) {
                            _refreshHabitList(); // Refresh after delete
                          });
                        }
                      },
                    ),
                    onTap: () {
                      _handleHabitTap(habit); // Handle tap on habit item
                    },
                  );
                },
                separatorBuilder: (context, index) => Divider(),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddHabitPage()),
          );
          _refreshHabitList(); // Refresh after adding new habit
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
