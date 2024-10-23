import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackSummaryModel.dart';
import 'package:team_adaptive/Module7_Teacher_Dashboard/ViewModels/LessonDashboardViewModel.dart';

class LessonDashboardView extends StatelessWidget {
  final String lessonID;
  final String courseID;
  final LessonDashboardViewModel lessonDashboardViewModel =
      LessonDashboardViewModel();
  LessonDashboardView(
      {super.key, required this.lessonID, required this.courseID});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: lessonDashboardViewModel,
      child: FutureBuilder<void>(
          future:
              lessonDashboardViewModel.getFeedbackSummaries(courseID, lessonID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child:
                      CircularProgressIndicator()); // Show a loading indicator
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                    child:
                        Text('Error: ${snapshot.error}')); // Handle any errors
              } else {
                return Consumer<LessonDashboardViewModel>(
                    builder: (context, viewModel, child) {
                  // Check if viewModel data is empty
                  if (viewModel.numberOfStudents == 0) {
                    return const Center(
                        child: Text('No students available for analysis.'));
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        DropdownMenu<int>(
                          initialSelection: 1,
                          dropdownMenuEntries: viewModel.maxAttempt > 0
                              ? List.generate(viewModel.maxAttempt, (index) {
                                  return DropdownMenuEntry(
                                    value: index + 1,
                                    label: (index + 1).toString(),
                                  );
                                })
                              : [],
                          onSelected: (value) {
                            if (value != null) {
                              viewModel.setAttemptNumber(value);
                            }
                          },
                        ),
                        Text(
                            "Number of students included in the analysis: ${viewModel.numberOfStudents}"),

                        // Learning Styles Pie Chart
                        const Text("Learning Styles"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 3,
                          child: viewModel
                                  .getLearningStylesPieSections()
                                  .isNotEmpty
                              ? PieChart(PieChartData(
                                  sectionsSpace: 0,
                                  sections:
                                      viewModel.getLearningStylesPieSections(),
                                ))
                              : const Center(
                                  child:
                                      Text('No learning style data available')),
                        ),

                        // Skill Levels Bar Chart
                        const Text("Skill levels"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 3,
                          child: viewModel.getSkillLvlBarChartData().isNotEmpty
                              ? BarChart(BarChartData(
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles:
                                            true, // Show labels on the left axis
                                        getTitlesWidget: (value, meta) {
                                          if (value == value.toInt()) {
                                            return Text(
                                              (value)
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
                                      ),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(
                                          showTitles:
                                              false), // Hide right axis labels
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(
                                          showTitles:
                                              false), // Hide top axis labels
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles:
                                            true, // Show labels on the bottom axis
                                        getTitlesWidget: (value, meta) {
                                          return Text(value
                                              .toString()); // Customize label if needed
                                        },
                                      ),
                                    ),
                                  ),
                                  maxY: viewModel.numberOfStudents.toDouble(),
                                  barGroups:
                                      viewModel.getSkillLvlBarChartData(),
                                ))
                              : const Center(
                                  child: Text('No skill level data available')),
                        ),

                        // Weak Concepts Pie Chart
                        const Text("Weak Concepts"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 3,
                          child: viewModel
                                  .getWeakConceptsPieSections()
                                  .isNotEmpty
                              ? PieChart(PieChartData(
                                  sectionsSpace: 0,
                                  sections:
                                      viewModel.getWeakConceptsPieSections(),
                                ))
                              : const Center(
                                  child:
                                      Text('No weak concepts data available')),
                        ),

                        // Other content such as LODashboard
                        const LODashboard(),
                      ],
                    ),
                  );
                });
              }
            } else {
              return const Text('Something unexpected happened');
            }
          }),
    );
  }
}

class LODashboard extends StatefulWidget {
  const LODashboard({super.key});

  @override
  State<LODashboard> createState() => _LODashboardState();
}

class _LODashboardState extends State<LODashboard> {
  late String selectedLO;
  @override
  void initState() {
    super.initState();
    selectedLO = Provider.of<LessonDashboardViewModel>(context, listen: false)
        .feedbackSummaries
        .first
        .lOsAndRateHistory
        .keys
        .first;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LessonDashboardViewModel>(
        builder: (context, viewModel, child) {
      return Column(
        children: [
          DropdownMenu(
              initialSelection:
                  viewModel.feedbackSummaries[0].lOsAndRateHistory.keys.first,
              onSelected: (value) {
                setState(() {
                  selectedLO = value!;
                });
              },
              dropdownMenuEntries: viewModel
                  .feedbackSummaries[0].lOsAndRateHistory.keys
                  .map((String lO) {
                return DropdownMenuEntry(value: lO, label: lO);
              }).toList()),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.height / 3,
            child: BarChart(BarChartData(
                maxY: viewModel.numberOfStudents.toDouble(),
                barGroups: getLOMasteryData(
                    selectedLO, viewModel), // Set the maximum Y value
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        );
                        switch (value.toInt()) {
                          case 3:
                            return const Text('Very Poorly Learned',
                                style: style);
                          case 2:
                            return const Text('Less Poorly Learned',
                                style: style);
                          case 1:
                            return const Text('Learned', style: style);
                          case 0:
                            return const Text('Well Learned', style: style);
                          default:
                            return const SizedBox.shrink();
                        }
                      },
                      reservedSize: 32, // Reserve space for the labels
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1, // Interval of Y-axis labels
                      getTitlesWidget: (value, meta) {
                        if (value == value.toInt()) {
                          return Text(
                            (value)
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
                    ),
                  ),
                ))),
          )
        ],
      );
    });
  }

  List<BarChartGroupData> getLOMasteryData(
      String lO, LessonDashboardViewModel viewModel) {
    List<int> tally = List.filled(4, 0);
    for (FeedbackSummaryModel feedbackSummaryModel
        in viewModel.filteredListByAttemptNumber) {
      double rate = feedbackSummaryModel
          .lOsAndRateHistory[lO]![viewModel.attemptNumber - 1];
      int index = rate == 0 ? 0 : (rate / 25).ceil() - 1;
      tally[index]++;
    }
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
              toY: tally[0].toDouble(), width: 22, color: Colors.blue),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
              toY: tally[1].toDouble(), width: 22, color: Colors.blue),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
              toY: tally[2].toDouble(), width: 22, color: Colors.blue),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
              toY: tally[3].toDouble(), width: 22, color: Colors.blue),
        ],
      ),
    ];
  }
}
