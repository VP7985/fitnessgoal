import 'package:fitnessgoal/database/database_healper.dart';
import 'package:flutter/material.dart';
import 'package:fitnessgoal/components/my_textfield.dart';
import 'package:fitnessgoal/components/my_button.dart';

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

      int habitId = await _databaseHelper.insertHabit(habit);
      if (habitId != -1) {
        Navigator.of(context).pop(); // Navigate back after saving habit
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to save habit. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Icon(
                Icons.description_sharp,
                size: 100,
              ),
              MyTextField(
                controller: habitTitle,
                lableText: 'Goal Title',
                obscureText: false,
                prefixIcon: Icons.title,
              ),
              MyTextField(
                controller: titleDescription,
                obscureText: false,
                prefixIcon: Icons.description,
                lableText: 'Description',
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 13, 71, 161),
                    ),
                    onPressed: () => _selectDate(context),
                    child: Text(
                      selectedDate == null
                          ? 'Select Date'
                          : 'Date: ${selectedDate!.toString().substring(0, 10)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 13, 71, 161),
                    ),
                    onPressed: () => _selectTime(context),
                    child: Text(
                      selectedTime == null
                          ? 'Select Time'
                          : 'Time: ${selectedTime!.format(context)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              MyButton(
                onTap: _saveHabit,
                text: 'Save Habit',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
