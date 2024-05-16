import 'package:fitnessgoal/database/database_healper.dart';
import 'package:flutter/material.dart';

import 'package:fitnessgoal/models/habit.dart';

class DeleteHabitPage extends StatelessWidget {
  final Habit habit;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  DeleteHabitPage({Key? key, required this.habit}) : super(key: key);

  Future<void> _deleteHabit(BuildContext context) async {
    await _databaseHelper.deleteHabit(habit.id!); // Ensure habit.id is not null
    Navigator.pop(context); // Return to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Deletion'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Are you sure you want to delete this habit?'),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _deleteHabit(context),
              child: Text('Delete Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
