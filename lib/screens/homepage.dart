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
  final String userName;
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
      _habitList = DatabaseHelper().getHabits(FirebaseAuth.instance.currentUser!.uid);
    });
  }

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    if (widget.onSignOut != null) {
      widget.onSignOut!();
    }
  }

  void goToProfilePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  void _handleHabitTap(Habit habit) {
    print('Tapped on habit: ${habit.title}');
    // Implement your desired behavior when tapping a habit item
  }

  Color _getProgressBarColor(DateTime dueDate) {
    final currentDate = DateTime.now();
    if (currentDate.isAfter(dueDate)) {
      // Past-due
      return Colors.red;
    } else if (currentDate.isBefore(dueDate)) {
      // Upcoming
      return Colors.blue;
    } else {
      // Due today (considered completed if not past-due)
      return Colors.green;
    }
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
            snapshot.data!.sort((a, b) => a.title.compareTo(b.title));
            return RefreshIndicator(
              onRefresh: () async {
                _refreshHabitList();
              },
              child: ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final habit = snapshot.data![index];
                  final currentDate = DateTime.now();
                  final dueDate = DateTime.parse(habit.date);
                  final totalDuration = dueDate.difference(currentDate).inSeconds;
                  final progress = (totalDuration - dueDate.difference(currentDate).inSeconds) / totalDuration;
                  final progressBarColor = _getProgressBarColor(dueDate);

                  return ListTile(
                    leading: Icon(Icons.check_circle_outline, color: Colors.green),
                    title: Text(
                      habit.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${habit.description}'),
                        Text('Date: ${habit.date}'),
                        Text('Time: ${habit.time}'),
                        LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
                        ),
                      ],
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
                          _refreshHabitList();
                        } else if (value == 'delete') {
                          showDialog(
                            context: context,
                            builder: (context) => DeleteHabitPage(habit: habit),
                          ).then((_) {
                            _refreshHabitList();
                          });
                        }
                      },
                    ),
                    onTap: () {
                      _handleHabitTap(habit);
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
          _refreshHabitList();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
