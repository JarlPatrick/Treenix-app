import 'package:home_widget/home_widget.dart';

import '_colors.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class TreenixStreak extends StatelessWidget {
  final List<Map<String, dynamic>> allActivities;

  // final Function(TreenixView) viewStateCallback;

  const TreenixStreak({
    required this.allActivities,
    // required this.viewStateCallback,
  });

  void SetStreak(int streak) async {
    String appGroupId = "group.homeScreenApp";
    String androidWidgetName = "MyHomeWidget";
    String dataKey = "text_from_flutter_app";
    HomeWidget.setAppGroupId(appGroupId);

    await HomeWidget.saveWidgetData(dataKey, streak.toString());
    await HomeWidget.updateWidget(androidName: androidWidgetName);
  }

  int calculateRunningStreak(List<DateTime> runStartTimes, DateTime now) {
    // Convert 'now' to UTC and normalize to remove the time part
    DateTime today = DateTime.utc(now.year, now.month, now.day);

    // Convert all dates to UTC and normalize them
    List<DateTime> normalizedDates = runStartTimes
        .map((date) => DateTime.utc(
            date.toUtc().year, date.toUtc().month, date.toUtc().day))
        .toSet() // Remove duplicates (same day runs)
        .toList()
      ..sort((a, b) => b.compareTo(a));

    // print(normalizedDates);

    int streak = 0;

    // Start streak checking
    for (int i = 0; i < normalizedDates.length; i++) {
      if (streak == 0) {
        // Check if the streak starts from today or yesterday
        if (normalizedDates[i] == today ||
            normalizedDates[i] == today.subtract(Duration(days: 1))) {
          streak++;
        }
      } else {
        // Check if the next date is exactly one day before the current date
        if (normalizedDates[i] ==
            normalizedDates[i - 1].subtract(Duration(days: 1))) {
          streak++;
        } else {
          break; // End the streak if a day is skipped
        }
      }
    }

    return streak;
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> allDates = [];
    for (var activity in allActivities) {
      if (activity['elapsed_time'] > 20 * 60) {
        allDates.add(DateTime.parse(activity['start_date']));
      }
    }
    DateTime today = DateTime.now();

    int streak = calculateRunningStreak(allDates, today);
    print("Streak $streak");
    SetStreak(streak);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        color: TreenixColors.grayBackground,
        child: InkWell(
          hoverColor: TreenixColors.primaryPink,
          onTap: () {
            // viewStateCallback(TreenixView.Calendar);
          },
          child: Container(
            width: 170,
            height: 160,
            padding: EdgeInsets.all(10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Streak",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    streak.toString(),
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Container(
    //   height: 160,
    //   width: 200,
    //   padding: EdgeInsets.all(10),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10),
    //     color: TreenixColors.grayBackground,
    //   ),
    //   child: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       mainAxisSize: MainAxisSize.max,
    //       children: [
    //         Text(
    //           "Streak",
    //           style: TextStyle(
    //             fontSize: 20,
    //             color: TreenixColors.primaryPink,
    //           ),
    //         ),
    //         Text(
    //           streak.toString(),
    //           style: TextStyle(
    //             fontSize: 50,
    //             color: TreenixColors.primaryPink,
    //           ),
    //         ),
    //         ElevatedButton(
    //           onPressed: () {
    //             viewStateCallback(TreenixView.Calendar);
    //           },
    //           style: ElevatedButton.styleFrom(
    //             backgroundColor: TreenixColors.lightGray,
    //           ),
    //           child: Text(
    //             "Calendar",
    //             style: TextStyle(
    //               fontSize: 13,
    //               color: TreenixColors.primaryPink,
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
