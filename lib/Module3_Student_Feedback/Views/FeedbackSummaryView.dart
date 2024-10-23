import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackSummaryModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Views/FeedbackView.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../Models/FeedbackModel.dart';

var color = const Color.fromARGB(255, 249, 235, 235);

class FeedbackSummaryView extends StatefulWidget {
  final FeedbackSummaryModel feedbackSummary;
  const FeedbackSummaryView({super.key, required this.feedbackSummary});

  @override
  State<FeedbackSummaryView> createState() => _FeedbackSummaryViewState();
}

class _FeedbackSummaryViewState extends State<FeedbackSummaryView> {
  late String selectedLO;
  @override
  void initState() {
    super.initState();
    selectedLO = widget.feedbackSummary.lOsAndRateHistory.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> conceptsAndFailureRates =
        widget.feedbackSummary.mostRecentLOsAndRates;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AssessmentLink(
                weak: widget.feedbackSummary.mostRecentWeakConcepts,
                courseID: widget.feedbackSummary.courseID,
                lessonID: widget.feedbackSummary.lessonID),
            const Text("Latest Feedback"),
            const SizedBox(height: 15),
            Text('Score: ${widget.feedbackSummary.mostRecentScore}',
                style: const TextStyle(fontSize: 24.0)),
            const SizedBox(height: 15),
            Text(
                'Learner Skill level: ${widget.feedbackSummary.mostRecentSkillLevel}',
                style: const TextStyle(fontSize: 24.0)),
            const SizedBox(height: 15),
            Text(
                'Category: ${widget.feedbackSummary.mostRecentCategorizedSkillLevel}',
                style: const TextStyle(fontSize: 24.0)),
            const SizedBox(height: 15),
            Text(
                'Suggested Learning Style: ${widget.feedbackSummary.mostRecentLearningStyle}',
                style: const TextStyle(fontSize: 24.0)),
            const SizedBox(height: 15),
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
                ...conceptsAndFailureRates.entries.map<TableRow>(
                  (entry) {
                    return TableRow(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          color: color,
                          padding: const EdgeInsets.all(10.0),
                          child: Text(entry.key,
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
                                  value: entry.value / 100,
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      10), // Optional: Add spacing between the progress bar and text
                              Text("${entry.value.toStringAsFixed(2)}%",
                                  style: const TextStyle(fontSize: 20.0)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text('Weak Concepts:', style: TextStyle(fontSize: 24.0)),
            const SizedBox(height: 15),
            ...widget.feedbackSummary.mostRecentWeakConcepts.map(
              (concept) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text(concept),
                    onPressed: () {
                      String lO = Uri.encodeFull(concept);
                      context.go(
                          '/materials/learning-outcome/$lO/${widget.feedbackSummary.mostRecentLearningStyle}',
                          extra: concept);
                    },
                  ),
                );
              },
            ),
            const Text("History"),
            const Text("Assessment scores"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 3,
                child: LineChart(LineChartData(
                    minY: 0,
                    maxY: widget.feedbackSummary.assessmentTotal.toDouble(),
                    minX: 0,
                    lineTouchData: LineTouchData(touchCallback: (event, touch) {
                      if (event is FlTapUpEvent) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: FeedbackView(
                                  feedback: widget.feedbackSummary
                                      .getFeedbackFromIndex(
                                          touch!.lineBarSpots!.first.spotIndex),
                                ),
                              );
                            });
                      }
                    }),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: false), // Disable top titles
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
                            reservedSize: 20), // Keep left titles
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: widget.feedbackSummary.scoreHistory
                            .asMap()
                            .entries
                            .map((entry) => FlSpot(
                                entry.key.toDouble(), entry.value.toDouble()))
                            .toList(),
                        isCurved: false,
                      )
                    ])),
              ),
            ),
            const Text("Learning Outcomes"),
            DropdownMenu<String>(
                initialSelection: selectedLO,
                dropdownMenuEntries: widget
                    .feedbackSummary.mostRecentLOsAndRates.keys
                    .map((String lO) {
                  return DropdownMenuEntry(value: lO, label: lO);
                }).toList(),
                onSelected: (value) {
                  setState(() {
                    selectedLO = value!;
                  });
                }),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 3,
                child: LineChart(LineChartData(
                    lineTouchData: LineTouchData(touchCallback: (event, touch) {
                      if (event is FlTapUpEvent) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: FeedbackView(
                                  feedback: widget.feedbackSummary
                                      .getFeedbackFromIndex(
                                          touch!.lineBarSpots!.first.spotIndex),
                                ),
                              );
                            });
                      }
                    }),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: false), // Disable top titles
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: false), // Disable right titles
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          interval: 1,
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
                          showTitles: true,
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
                    minY: 0,
                    maxY: 100,
                    minX: 0,
                    lineBarsData: [
                      LineChartBarData(
                          spots: widget
                              .feedbackSummary.lOsAndRateHistory[selectedLO]!
                              .asMap()
                              .entries
                              .map((entry) => FlSpot(
                                  entry.key.toDouble(),
                                  double.parse((entry.value.toDouble() * 100)
                                          .round()
                                          .toString()) /
                                      100))
                              .toList(),
                          isCurved: false)
                    ])),
              ),
            ),
            const Text("Skill levels"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 3,
                child: LineChart(LineChartData(
                    lineTouchData: LineTouchData(touchCallback: (event, touch) {
                      if (event is FlTapUpEvent) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: FeedbackView(
                                  feedback: widget.feedbackSummary
                                      .getFeedbackFromIndex(
                                          touch!.lineBarSpots!.first.spotIndex),
                                ),
                              );
                            });
                      }
                    }),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: false), // Disable top titles
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
                            }), // Keep bottom titles
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
                            reservedSize: 20), // Keep left titles
                      ),
                    ),
                    minY: 0,
                    maxY: 10,
                    minX: 0,
                    lineBarsData: [
                      LineChartBarData(
                          spots: widget.feedbackSummary.skillLvlHistory
                              .asMap()
                              .entries
                              .map((entry) => FlSpot(
                                  entry.key.toDouble(), entry.value.toDouble()))
                              .toList(),
                          isCurved: false)
                    ])),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AssessmentLink extends StatefulWidget {
  final List<String> weak;
  final String courseID;
  final String lessonID;
  const AssessmentLink(
      {super.key,
      required this.weak,
      required this.courseID,
      required this.lessonID});

  @override
  State<AssessmentLink> createState() => _AssessmentLinkState();
}

class _AssessmentLinkState extends State<AssessmentLink> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
            onPressed: () {
              if (isChecked) {
                String serializedItems =
                    Uri.encodeFull(widget.weak.join('|~|'));
                GoRouter.of(context).go(
                    '/courses/${widget.courseID}/lessons/${widget.lessonID}/assessment?weak=$serializedItems');
              } else {
                GoRouter.of(context).go(
                    '/courses/${widget.courseID}/lessons/${widget.lessonID}/assessment');
              }
            },
            child: const Text('Take assessment again')),
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value ?? false; // Update the checkbox state
            });
          },
        ),
        const Text('exclude mastered learning outcomes?')
      ],
    );
  }
}
