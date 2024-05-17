import 'package:fitnessgoal/components/my_button.dart';
import 'package:fitnessgoal/components/my_textfield.dart';
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
          title: Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Please fill in all fields.',
            style: TextStyle(fontSize: 16),
          ),
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
        title: Text('Add Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create A Goal",
              style: TextStyle(
                fontSize: 33,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            // Changed 'label' to 'Text'
            SizedBox(height: 20),
            Center(
              child: MyTextField(
                controller: habitTitle,
                obscureText: false,
                prefixIcon: Icons.title,
                lableText: 'Goal Title',
              ),
            ),
            SizedBox(height: 20),
            MyTextField(
              controller: titleDescription,
              obscureText: false,
              prefixIcon: Icons.description,
              lableText: 'Goal Description',
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 13, 71, 161),
                  ),
                  onPressed: () => _selectDate(context),
                  child: Text(
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    selectedDate == null
                        ? 'Select Date'
                        : 'Date: ${selectedDate!.toString().substring(0, 10)}',
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 13, 71, 161),
                  ),
                  onPressed: () => _selectTime(context),
                  child: Text(
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      selectedTime == null
                          ? 'Select Time'
                          : 'Time: ${selectedTime!.format(context)}'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: 500, // Set the desired width
              height: 50.0,
              child: ElevatedButton(
                onPressed: _saveHabit,
                child: Text(
                  'Save Habit',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 13, 71, 161),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
