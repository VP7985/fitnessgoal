import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessgoal/components/my_button.dart';
import 'package:fitnessgoal/components/my_textfield.dart';

class AddGoalPage extends StatefulWidget {
  @override
  _AddGoalPageState createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedAlert;

  final CollectionReference goalsCollection =
      FirebaseFirestore.instance.collection('goals');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Goal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              MyTextField(
                controller: _titleController,
                lableText: 'Title',
                prefixIcon: Icons.title,
                obscureText: false,
              ),
              SizedBox(height: 16),
              MyTextField(
                controller: _descriptionController,
                lableText: 'Description',
                prefixIcon: Icons.description,
                obscureText: false,
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Select Date'),
                subtitle: Text(_selectedDate == null
                    ? 'No date chosen!'
                    : _formatDate(_selectedDate!)),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Select Time'),
                subtitle: Text(_selectedTime == null
                    ? 'No time chosen!'
                    : _selectedTime!.format(context)),
                trailing: Icon(Icons.access_time),
                onTap: _pickTime,
              ),
              SizedBox(height: 16),
              Text('Select Alert'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAlertTag('Red', Colors.red),
                  _buildAlertTag('Green', Colors.green),
                  _buildAlertTag('Yellow', Colors.yellow),
                ],
              ),
              SizedBox(height: 16),
              MyButton(
                onTap: _submit,
                text: ('Add Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_addLeadingZeroIfNeeded(date.month)}-${_addLeadingZeroIfNeeded(date.day)}';
  }

  String _addLeadingZeroIfNeeded(int value) {
    if (value < 10) {
      return '0$value';
    }
    return '$value';
  }

  Widget _buildAlertTag(String label, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAlert = label;
        });
      },
      child: Chip(
        label: Text(label),
        backgroundColor: color,
        avatar: _selectedAlert == label
            ? Icon(Icons.check, color: Colors.white)
            : null,
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final newGoal = {
          'userId': user.uid, // Include user's UID
          'title': _titleController.text,
          'description': _descriptionController.text,
          'date': _selectedDate != null ? _formatDate(_selectedDate!) : null,
          'time': _selectedTime != null ? _selectedTime!.format(context) : null,
          'type': _selectedAlert,
        };
        try {
          await goalsCollection.add(newGoal);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Goal added successfully!')),
          );
          Navigator.pop(context); // Go back to the home page
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add goal: $error')),
          );
        }
      }
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: AddGoalPage(),
  ));
}
