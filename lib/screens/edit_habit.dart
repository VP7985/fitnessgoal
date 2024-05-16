import 'package:fitnessgoal/database/database_healper.dart';
import 'package:flutter/material.dart';

import 'package:fitnessgoal/models/habit.dart';

class EditHabitPage extends StatefulWidget {
  final Habit habit;

  const EditHabitPage({Key? key, required this.habit}) : super(key: key);

  @override
  _EditHabitPageState createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  final TextEditingController habitTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    habitTitleController.text = widget.habit.title;
    descriptionController.text = widget.habit.description;
  }

  Future<void> _updateHabit() async {
    final updatedHabit = Habit(
      id: widget.habit.id,
      title: habitTitleController.text,
      description: descriptionController.text,
      date: widget.habit.date,
      time: widget.habit.time,
    );

    await _databaseHelper.updateHabit(updatedHabit);
    Navigator.of(context).pop(); // Navigate back after updating habit
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Habit'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: habitTitleController,
              decoration: InputDecoration(labelText: 'Habit Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _updateHabit,
              child: Text('Update Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
