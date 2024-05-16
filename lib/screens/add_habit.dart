import 'package:fitnessgoal/database/database_healper.dart';
import 'package:flutter/material.dart';

import 'package:fitnessgoal/models/habit.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({Key? key}) : super(key: key);

  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final habitTitle = TextEditingController();
  final titleDescription = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> _saveHabit() async {
    if (habitTitle.text.isNotEmpty &&
        titleDescription.text.isNotEmpty &&
        selectedDate != null &&
        selectedTime != null) {
      final habit = Habit(
        title: habitTitle.text,
        description: titleDescription.text,
        date: selectedDate!.toString(),
        time: selectedTime!.format(context),
      );

      await _databaseHelper.insertHabit(habit);
      Navigator.of(context).pop(); // Navigate back after saving habit
    } else {
      // Show error message if fields are empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please fill in all fields.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Habit'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: habitTitle,
              decoration: InputDecoration(labelText: 'Goal Title'),
            ),
            TextField(
              controller: titleDescription,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(selectedDate == null
                      ? 'Select Date'
                      : 'Date: ${selectedDate!.toString().substring(0, 10)}'),
                ),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: Text(selectedTime == null
                      ? 'Select Time'
                      : 'Time: ${selectedTime!.format(context)}'),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveHabit,
              child: Text('Save Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
