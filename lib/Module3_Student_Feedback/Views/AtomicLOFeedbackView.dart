import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackSummaryModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/ViewModels/FeedbackViewModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Views/FeedbackView.dart';

var color = const Color.fromARGB(255, 249, 235, 235);

class AtomicLOFeedbackView extends StatefulWidget {
  final String learningOutcome;
  final String userID;
  const AtomicLOFeedbackView(
      {super.key, required this.learningOutcome, required this.userID});

  @override
  State<AtomicLOFeedbackView> createState() => _AtomicLOFeedbackViewState();
}

class _AtomicLOFeedbackViewState extends State<AtomicLOFeedbackView> {
  late final Future<FeedbackSummaryModel?> future;

  @override
  void initState() {
    super.initState();
    future = Provider.of<FeedbackViewModel>(context, listen: false)
        .getFeedbackFromLOAndUserID(widget.learningOutcome,
            userID: widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FeedbackSummaryModel?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), // Show loading spinner
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'), // Show error message
            );
          } else if (snapshot.hasData) {
            final feedbackSummary = snapshot.data;
            final latestOfLO = feedbackSummary!
                .lOsAndRateHistory[widget.learningOutcome]!.last;
            return Column(
              children: [
                const Text('Current state:'),
                Table(
                  children: [
                    TableRow(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.all(10.0),
                          child: const Text("Concept",
                              style: TextStyle(fontSize: 24.0)),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.all(10.0),
                          child: const Text("Failure Rate",
                              style: TextStyle(fontSize: 24.0)),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          color: color,
                          padding: const EdgeInsets.all(10.0),
                          child: Text(widget.learningOutcome,
                              style: const TextStyle(fontSize: 20.0)),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          color: color,
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 200, // specify the width you want
                                child: LinearProgressIndicator(
                                  minHeight: 20,
                                  value: latestOfLO / 100,
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      10), // Optional: Add spacing between the progress bar and text
                              Text("${latestOfLO.toStringAsFixed(2)}%",
                                  style: const TextStyle(fontSize: 20.0)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 3,
                    child: LineChart(LineChartData(
                        lineTouchData:
                            LineTouchData(touchCallback: (event, touch) {
                          if (event is FlTapUpEvent) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: FeedbackView(
                                      feedback: feedbackSummary
                                          .getFeedbackFromIndex(touch!
                                              .lineBarSpots!.first.spotIndex),
                                    ),
                                  );
                                });
                          }
                        }),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: false), // Disable top titles
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: false), // Disable right titles
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              interval: 1,
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value == value.toInt()) {
                                  return Text(
                                    (value + 1)
                                        .toInt()
                                        .toString(), // This ensures integer display
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                            ), // Keep bottom titles
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                                getTitlesWidget: (value, meta) {
                                  if (value == value.toInt()) {
                                    return Text(
                                      value
                                          .toInt()
                                          .toString(), // This ensures integer display
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                                showTitles: true,
                                reservedSize: 40), // Keep left titles
                          ),
                        ),
                        maxY: 100,
                        lineBarsData: [
                          LineChartBarData(
                            spots: feedbackSummary
                                .lOsAndRateHistory[widget.learningOutcome]!
                                .asMap()
                                .entries
                                .map((entry) => FlSpot(entry.key.toDouble(),
                                    entry.value.toDouble()))
                                .toList(),
                            isCurved: false,
                          )
                        ])),
                  ),
                )
              ],
            );
          } else {
            return const Center(
              child: Text('No data'),
            );
          }
        });
  }
}
