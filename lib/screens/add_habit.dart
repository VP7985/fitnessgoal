import 'package:fitnessgoal/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:fitnessgoal/auth/login_reg.dart';
import 'package:fitnessgoal/components/my_textfield.dart';
import 'package:fitnessgoal/screens/homepage.dart';
import 'package:fitnessgoal/screens/login.dart';
import 'package:fitnessgoal/screens/profile_page.dart';
import 'package:fitnessgoal/database/database_healper.dart'; // Import the database helper
import 'package:fitnessgoal/models/habit.dart'; // Import the habit model

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

  Future<void> _saveHabit() async {
    if (habitTitle.text.isNotEmpty &&
        titleDescription.text.isNotEmpty &&
        selectedDate != null &&
        selectedTime != null) {
      final habit = Habit(
        title: habitTitle.text,
        description: titleDescription.text,
        date: selectedDate!.toString().substring(0, 10),
        time: selectedTime!.format(context),
      );
      await DatabaseHelper().insertHabit(habit);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
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
              SizedBox(height: 25),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
                    Center(
                      child: MyTextField(
                        controller: habitTitle,
                        obscureText: false,
                        prefixIcon: Icons.title,
                        lableText: 'Habit Title',
                      ),
                    ),
                    SizedBox(height: 20),
                    MyTextField(
                      controller: titleDescription,
                      obscureText: false,
                      prefixIcon: Icons.description,
                      lableText: 'Habit Description',
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    MyButton(
                      onTap: _saveHabit,
                      text: ('Save Habit'),
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
}
