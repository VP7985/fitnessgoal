import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fitnessgoal/components/habittiles.dart';

class habiittracker extends StatefulWidget {
  const habiittracker({super.key});

  @override
  State<habiittracker> createState() => _habiittrackerState();
}

class _habiittrackerState extends State<habiittracker> {
  //overall habir summary
  List habitlist = [
    ['Exercise', false, 0, 10],
    ['Read', false, 0, 20],
    ['Meditate', false, 0, 20],
    ['Code', false, 0, 40],
  ];

  void habitStarted(int index) {
    //note what the start time is
    var startTime = DateTime.now();
    int elapsedTime = habitlist[index][2];
    //habit  started or stopped
    setState(() {
      habitlist[index][1] = !habitlist[index][1];
    });

    //keep the time going
    if (habitlist[index][1]) {
      Timer.periodic(
        Duration(seconds: 1),
        (timer) {
           
          if (habitlist[index][1]) {
            timer.cancel();
          }
          //calculate the time elapsed by comparing current.
          var currentTime = DateTime.now();
          habitlist[index][2] = elapsedTime +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
          setState(() {
            habitlist[index][2]++;
          });
        },
      );
    }
  }

  void settingsOpened(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Settings for ' + habitlist[index][0]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 52, 145, 231),
        title: const Text('Consistency is key.'),
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: habitlist.length,
        itemBuilder: ((context, index) {
          return HabitTile(
            habitName: habitlist[index][0],
            onTap: () {
              habitStarted(index);
            },
            settingsTapped: () {
              settingsOpened(index);
            },
            timespent: habitlist[index][2],
            timeGoal: habitlist[index][3],
            habitStarted: habitlist[index][1],
          );
        }),
      ),
    );
  }
}
