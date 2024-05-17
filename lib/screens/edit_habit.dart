import 'package:fitnessgoal/database/database_healper.dart';
import 'package:flutter/material.dart';

import 'package:fitnessgoal/models/habit.dart';
import 'package:intl/intl.dart';

class EditHabitPage extends StatefulWidget {
  final Habit habit;

  const EditHabitPage({Key? key, required this.habit}) : super(key: key);

  @override
  _EditHabitPageState createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  final TextEditingController habitTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    habitTitleController.text = widget.habit.title;
    descriptionController.text = widget.habit.description;

    try {
      // Parse date string from habit
      selectedDate = DateTime.parse(widget.habit.date);
    } catch (e) {
      // Handle parsing error for date
      print('Error parsing date: $e');
      selectedDate = DateTime.now(); // Use default date if parsing fails
    }

    try {
      // Parse time string from habit
      DateTime habitTime = DateFormat('HH:mm').parse(widget.habit.time);
      selectedTime = TimeOfDay.fromDateTime(habitTime);
    } catch (e) {
      // Handle parsing error for time
      print('Error parsing time: $e');
      selectedTime = TimeOfDay.now(); // Use default time if parsing fails
    }
  }

  Future<void> _updateHabit() async {
    final updatedHabit = Habit(
      id: widget.habit.id,
      title: habitTitleController.text,
      description: descriptionController.text,
      date: DateFormat('yyyy-MM-dd').format(selectedDate),
      time: DateFormat('HH:mm').format(DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      )),
    );

    await _databaseHelper.updateHabit(updatedHabit);
    Navigator.of(context).pop(); // Navigate back after updating habit
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
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
      initialTime: selectedTime,
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
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date',
                      ),
                      child: Text(DateFormat.yMMMd().format(selectedDate)),
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Time',
                      ),
                      child: Text(selectedTime.format(context)),
                    ),
                  ),
                ),
              ],
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