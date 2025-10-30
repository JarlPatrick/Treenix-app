import '_colors.dart';
// import 'home.dart';
import 'package:flutter/material.dart';

class JarlsNumber extends StatelessWidget {
  final List<Map<String, dynamic>>
      allActivities; // List of all activities with detailed info

  // final Function(TreenixView) viewStateCallback;
  final int year;

  JarlsNumber({
    required this.allActivities,
    // required this.viewStateCallback,
    required this.year,
  });

  int findLargestX(List<int> items) {
    // Sort the list in descending order
    items.sort((a, b) => b.compareTo(a));
    // print(items);
    // Find the largest X
    for (int i = 0; i < items.length; i++) {
      // print("${i + 1}  ${items[i]}");
      if (i + 1 >= items[i]) {
        return i + 1;
      }
    }

    // If no such X is found, return 0
    return items.length;
  }

  @override
  Widget build(BuildContext context) {
    List<int> AllTimes = [];
    List<int> ThisYearTimes = [];
    List<int> LastYearTimes = [];
    List<int> LastQuarterTimes = [];
    for (var activity in allActivities) {
      int durationSeconds = activity['moving_time'] ~/ 60;
      AllTimes.add(durationSeconds);
      final parsedDate = DateTime.parse(activity['start_date']);
      if (parsedDate.year == year) {
        ThisYearTimes.add(durationSeconds);
      }
      if (DateTime.now().difference(parsedDate).inDays < 365) {
        LastYearTimes.add(durationSeconds);
      }
      if (DateTime.now().difference(parsedDate).inDays < 90) {
        LastQuarterTimes.add(durationSeconds);
      }
    }
    int AllTimesJN = findLargestX(AllTimes);
    int ThisYearJN = findLargestX(ThisYearTimes);
    int LastYearJN = findLargestX(LastYearTimes);
    int LastQuarterJN = findLargestX(LastQuarterTimes);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        color: TreenixColors.grayBackground,
        child: InkWell(
          hoverColor: TreenixColors.primaryPink,
          onTap: () {
            // viewStateCallback(TreenixView.JGraph);
          },
          child: Container(
            width: 400,
            height: 110,
            padding: EdgeInsets.all(10),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "J-INDEX",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            AllTimesJN.toString(),
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "ALL TIME",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            LastYearJN.toString(),
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "LAST 356 DAYS",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            ThisYearJN.toString(),
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "YEAR $year",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            LastQuarterJN.toString(),
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "LAST 90 DAYS",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    //  Container(
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
    //           "J-index",
    //           style: TextStyle(
    //             fontSize: 20,
    //             color: TreenixColors.primaryPink,
    //           ),
    //         ),
    //         Text(
    //           JN.toString(),
    //           style: TextStyle(
    //             fontSize: 50,
    //             color: TreenixColors.primaryPink,
    //           ),
    //         ),
    //         ElevatedButton(
    //           onPressed: () {
    //             viewStateCallback(TreenixView.JGraph);
    //           },
    //           style: ElevatedButton.styleFrom(
    //             backgroundColor: TreenixColors.lightGray,
    //           ),
    //           child: Text(
    //             "Graph",
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
