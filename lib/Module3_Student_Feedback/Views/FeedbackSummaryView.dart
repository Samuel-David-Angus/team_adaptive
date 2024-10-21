import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackSummaryModel.dart';
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
                      context.go('/materials/learning-outcome/$lO',
                          extra: concept);
                    },
                  ),
                );
              },
            ),
            const Text("History"),
            const Text("Assessment scores"),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 3,
              child: LineChart(LineChartData(
                  maxY: widget.feedbackSummary.assessmentTotal.toDouble(),
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
            const Text("Learning Outcomes"),
            DropdownButton<String>(
                value: selectedLO,
                items: widget.feedbackSummary.mostRecentLOsAndRates.keys
                    .map((String lO) {
                  return DropdownMenuItem(
                    value: lO,
                    child: Text(lO),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLO = value!;
                  });
                }),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 3,
              child: LineChart(LineChartData(minY: 0, maxY: 100, lineBarsData: [
                LineChartBarData(
                    spots: widget.feedbackSummary.lOsAndRateHistory[selectedLO]!
                        .asMap()
                        .entries
                        .map((entry) => FlSpot(
                            entry.key.toDouble(), entry.value.toDouble()))
                        .toList(),
                    isCurved: false)
              ])),
            ),
            const Text("Skill levels"),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 3,
              child: LineChart(LineChartData(minY: 0, maxY: 10, lineBarsData: [
                LineChartBarData(
                    spots: widget.feedbackSummary.skillLvlHistory
                        .asMap()
                        .entries
                        .map((entry) => FlSpot(
                            entry.key.toDouble(), entry.value.toDouble()))
                        .toList(),
                    isCurved: false)
              ])),
            )
          ],
        ),
      ),
    );
  }
}
