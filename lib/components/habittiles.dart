import 'package:flutter/material.dart';
import 'package:fitnessgoal/components/habittiles.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final VoidCallback onTap;
  final VoidCallback settingsTapped;
  final int timespent;
  final int timeGoal;
  final bool habitStarted;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.onTap,
    required this.habitStarted,
    required this.timeGoal,
    required this.settingsTapped,
    required this.timespent,
  });

  //convert seconds into min:sec
  String formatToMinSec(int totalSeconds) {
    String secs = (totalSeconds % 60).toString();
    String mins = (totalSeconds / 60).toStringAsFixed(1);

//if sec is a 1 digit number
    if (secs.length == 1) {
      secs = '0' + secs;
    }

    //if mins is a 1 digit number
    if (mins[1] == '.') {
      mins = mins.substring(0, 1);
    }
    return mins + ':' + secs;
  }

  //calculate progress percentages

  double percentcomplete() {
    return timespent / (timeGoal * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: SizedBox(
                    height: 60,
                    width: 50,
                    child: Stack(children: [
                      CircularPercentIndicator(
                        radius: 50,
                        percent: percentcomplete() < 1 ? percentcomplete() : 1,
                        progressColor: percentcomplete() > 0.5
                            ? (percentcomplete() > 0.75
                                ? Colors.green
                                : Colors.orange)
                            : Colors.red,
                      ),
                      //play pause button
                      Center(
                        child: Icon(
                          habitStarted ? Icons.pause : Icons.play_arrow,
                        ),
                      )
                    ]),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //habit_name
                    Text(
                      habitName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    //progress
                    Text(
                      formatToMinSec(timespent) +
                          '/' +
                          timeGoal.toString() +
                          ' = ' +
                          (percentcomplete() * 100).toStringAsFixed(0) +
                          '%',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                //progress circle
              ],
            ),
            GestureDetector(
              onTap: settingsTapped,
              child: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
