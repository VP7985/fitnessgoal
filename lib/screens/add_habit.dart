import 'package:flutter/material.dart';
import 'package:fitnessgoal/auth/login_reg.dart';

import 'package:fitnessgoal/components/my_textfield.dart';
import 'package:fitnessgoal/screens/homepage.dart';
import 'package:fitnessgoal/screens/login.dart';
import 'package:fitnessgoal/screens/profile_page.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({Key? key}) : super(key: key);

  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final habitTitle = TextEditingController();
  final titleDescription = TextEditingController();
  late FixedExtentScrollController _controller;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController();
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
      backgroundColor: Colors.grey[300],
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 25,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => HomePage(
                        userName: 'Text',
                        onProfile: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                        },
                        onSignOut: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginOrReg(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.arrow_back),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create A Habit",
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 50),
                    label("Habit Title"),
                    SizedBox(height: 20),
                    MyTextField(
                      controller: habitTitle,
                      obscureText: true,
                      prefixIcon: Icons.title,
                      lableText: 'Habit Title',
                    ),
                    SizedBox(height: 20),
                    MyTextField(
                      controller: titleDescription,
                      obscureText: true,
                      prefixIcon: Icons.description,
                      lableText: 'Habit Description',
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: Text(selectedDate == null
                              ? 'Select Date'
                              : 'Date: ${selectedDate!.toString().substring(0, 10)}'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _selectTime(context),
                          child: Text(selectedTime == null
                              ? 'Select Time'
                              : 'Time: ${selectedTime!.format(context)}'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Save habit details and navigate back to HomePage
                        Navigator.pop(context);
                      },
                      child: Text('Save Habit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget label(String label) {
  return Text(
    label,
    style: TextStyle(
      fontSize: 22,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  );
}
