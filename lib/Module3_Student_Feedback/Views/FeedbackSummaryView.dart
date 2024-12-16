import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackSummaryModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Views/FeedbackView.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

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

  bool _isAscending = true;
  bool _failureRate = true;
  bool _showGraphs = false;

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
    });
  }

  void _toggleFailureRate() {
    setState(() {
      _failureRate = !_failureRate;
    });
  }

  void _toggleShowGraphs() {
    setState(() {
      _showGraphs = !_showGraphs;
    });
  }

  List<String> _getSkillLevel(List<int> skillLvlHistory) {
    List<String> skillLevel = [];
    for (int i = 0; i < skillLvlHistory.length; i++) {
      skillLevel
          .add(widget.feedbackSummary.categorizeSkillLevel(skillLvlHistory[i]));
    }
    return skillLevel;
  }

  @override
  Widget build(BuildContext context) {
    List<int> sortedIndices = List<int>.generate(
        widget.feedbackSummary.scoreHistory.length, (index) => index);
    sortedIndices
        .sort((a, b) => _isAscending ? a.compareTo(b) : b.compareTo(a));

    Map<String, double> conceptsAndFailureRates =
        widget.feedbackSummary.mostRecentLOsAndRates;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const Center(
                  child: Text("Latest Feedback",
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ))),
              const SizedBox(height: 30),
              Center(
                  child: Column(children: [
                Text(
                    'Score: ${widget.feedbackSummary.mostRecentScore} / ${widget.feedbackSummary.assessmentTotal}',
                    style: const TextStyle(
                      fontSize: 21.0,
                    )),
                const SizedBox(height: 15),
                Text(
                    'Learner Skill level: ${widget.feedbackSummary.mostRecentSkillLevel}',
                    style: const TextStyle(fontSize: 21.0)),
                const SizedBox(height: 15),
                Text(
                    'Category: ${widget.feedbackSummary.mostRecentCategorizedSkillLevel}',
                    style: const TextStyle(fontSize: 21.0)),
                const SizedBox(height: 15),
                Text(
                    'Suggested Learning Style: ${widget.feedbackSummary.mostRecentLearningStyle}',
                    style: const TextStyle(fontSize: 21.0)),
              ])),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Table(
                            children: [
                              TableRow(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Text("Concept",
                                        style: TextStyle(fontSize: 24.0)),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Text("Failure Rate",
                                        style: TextStyle(fontSize: 24.0)),
                                  ),
                                ],
                              ),
                              ...conceptsAndFailureRates.entries
                                  .map<TableRow>((entry) {
                                return TableRow(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      color: color,
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(entry.key,
                                          style:
                                              const TextStyle(fontSize: 20.0)),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      color: color,
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                8,
                                            child: LinearProgressIndicator(
                                              minHeight: 20,
                                              value: entry.value / 100,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                              "${entry.value.toStringAsFixed(2)}%",
                                              style: const TextStyle(
                                                  fontSize: 20.0)),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        )),
                    const SizedBox(width: 15),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                  child: Text('Weaknesses',
                                      style: TextStyle(fontSize: 24.0))),
                              const SizedBox(height: 15),
                              SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    children: widget
                                        .feedbackSummary.mostRecentWeakConcepts
                                        .map(
                                      (concept) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                            child: Text(concept),
                                            onPressed: () {
                                              String lO =
                                                  Uri.encodeFull(concept);
                                              context.go(
                                                '/materials/learning-outcome/$lO/${widget.feedbackSummary.mostRecentLearningStyle}',
                                                extra: concept,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.15,
                  height: 500,
                  child: Card(
                      elevation: 4,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                    child: Text('History',
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ))),
                                Container(
                                    padding: const EdgeInsets.all(24.0),
                                    child: SingleChildScrollView(
                                        child: Table(
                                            border: TableBorder.all(
                                                color: Colors.black),
                                            columnWidths: const <int,
                                                TableColumnWidth>{
                                              0: FlexColumnWidth(0.7),
                                              1: FlexColumnWidth(1),
                                              2: FlexColumnWidth(5),
                                              3: FlexColumnWidth(1),
                                            },
                                            defaultVerticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            children: [
                                              TableRow(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                ),
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      _buildHeader("Ass. No.",
                                                          0, null, null),
                                                      IconButton(
                                                        icon: Icon(_isAscending
                                                            ? Icons.arrow_upward
                                                            : Icons
                                                                .arrow_downward),
                                                        onPressed:
                                                            _toggleSortOrder,
                                                      ),
                                                    ],
                                                  ),
                                                  _buildHeader(
                                                      "Assessment Scores",
                                                      1,
                                                      null,
                                                      null),
                                                  _buildHeader(
                                                    _failureRate
                                                        ? "Failure Rates"
                                                        : "Success Rates",
                                                    2,
                                                    widget.feedbackSummary
                                                        .lOsAndRateHistory,
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.swap_horiz),
                                                      onPressed:
                                                          _toggleFailureRate,
                                                    ),
                                                  ),
                                                  _buildHeader("Skill Level", 3,
                                                      null, null),
                                                ],
                                              ),
                                              ...sortedIndices.map((entry) {
                                                return TableRow(
                                                  children: [
                                                    _buildClickableTextCell(
                                                        (entry + 1).toString(),
                                                        entry),
                                                    _buildCell(
                                                        '${widget.feedbackSummary.scoreHistory[entry].toString()} / ${widget.feedbackSummary.assessmentTotal}'),
                                                    _scrollableTable(
                                                        widget.feedbackSummary
                                                            .lOsAndRateHistory,
                                                        false,
                                                        entry),
                                                    _buildCell(_getSkillLevel(
                                                            widget
                                                                .feedbackSummary
                                                                .skillLvlHistory)[
                                                        entry]),
                                                  ],
                                                );
                                              }),
                                            ])))
                              ]))),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(children: [
                    SizedBox(
                        child: Row(children: [
                      const Text("Show Graphs"),
                      Switch(
                        value: _showGraphs,
                        onChanged: (value) {
                          _toggleShowGraphs();
                        },
                      ),
                    ])),
                    const SizedBox(width: 500),
                    if (AuthServices().userInfo!.type == "student")
                      AssessmentLink(
                          weak: widget.feedbackSummary.mostRecentWeakConcepts,
                          courseID: widget.feedbackSummary.courseID,
                          lessonID: widget.feedbackSummary.lessonID),
                  ])
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              _showGraphs
                  ? SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Text("Assessment scores"),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      child: LineChart(
                                        LineChartData(
                                          minY: 0,
                                          maxY: widget
                                              .feedbackSummary.assessmentTotal
                                              .toDouble(),
                                          minX: 0,
                                          lineTouchData: LineTouchData(
                                            touchCallback: (event, touch) {
                                              if (event is FlTapUpEvent) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: FeedbackView(
                                                        feedback: widget
                                                            .feedbackSummary
                                                            .getFeedbackFromIndex(
                                                                touch!
                                                                    .lineBarSpots!
                                                                    .first
                                                                    .spotIndex),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                          titlesData: FlTitlesData(
                                            topTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles:
                                                      false), // Disable top titles
                                            ),
                                            rightTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles:
                                                      false), // Disable right titles
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
                                                reservedSize:
                                                    20, // Keep left titles
                                              ),
                                            ),
                                          ),
                                          lineBarsData: [
                                            LineChartBarData(
                                              spots: widget
                                                  .feedbackSummary.scoreHistory
                                                  .asMap()
                                                  .entries
                                                  .map((entry) => FlSpot(
                                                      entry.key.toDouble(),
                                                      entry.value.toDouble()))
                                                  .toList(),
                                              isCurved: false,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text("Failure rates"),
                                  DropdownMenu<String>(
                                    initialSelection: selectedLO,
                                    dropdownMenuEntries: widget.feedbackSummary
                                        .mostRecentLOsAndRates.keys
                                        .map((String lO) {
                                      return DropdownMenuEntry(
                                          value: lO, label: lO);
                                    }).toList(),
                                    onSelected: (value) {
                                      setState(() {
                                        selectedLO = value!;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      child: LineChart(
                                        LineChartData(
                                          lineTouchData: LineTouchData(
                                            touchCallback: (event, touch) {
                                              if (event is FlTapUpEvent) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: FeedbackView(
                                                        feedback: widget
                                                            .feedbackSummary
                                                            .getFeedbackFromIndex(
                                                                touch!
                                                                    .lineBarSpots!
                                                                    .first
                                                                    .spotIndex),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                          titlesData: FlTitlesData(
                                            topTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles:
                                                      false), // Disable top titles
                                            ),
                                            rightTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles:
                                                      false), // Disable right titles
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
                                                reservedSize:
                                                    40, // Keep left titles
                                              ),
                                            ),
                                          ),
                                          minY: 0,
                                          maxY: 100,
                                          minX: 0,
                                          lineBarsData: [
                                            LineChartBarData(
                                              spots: widget
                                                  .feedbackSummary
                                                  .lOsAndRateHistory[
                                                      selectedLO]!
                                                  .asMap()
                                                  .entries
                                                  .map((entry) => FlSpot(
                                                      entry.key.toDouble(),
                                                      double.parse((entry.value
                                                                      .toDouble() *
                                                                  100)
                                                              .round()
                                                              .toString()) /
                                                          100))
                                                  .toList(),
                                              isCurved: false,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text("Skill levels"),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      child: LineChart(
                                        LineChartData(
                                          lineTouchData: LineTouchData(
                                            touchCallback: (event, touch) {
                                              if (event is FlTapUpEvent) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: FeedbackView(
                                                        feedback: widget
                                                            .feedbackSummary
                                                            .getFeedbackFromIndex(
                                                                touch!
                                                                    .lineBarSpots!
                                                                    .first
                                                                    .spotIndex),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                          titlesData: FlTitlesData(
                                            topTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles:
                                                      false), // Disable top titles
                                            ),
                                            rightTitles: const AxisTitles(
                                              sideTitles: SideTitles(
                                                  showTitles:
                                                      false), // Disable right titles
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
                                                reservedSize:
                                                    20, // Keep left titles
                                              ),
                                            ),
                                          ),
                                          minY: 0,
                                          maxY: 10,
                                          minX: 0,
                                          lineBarsData: [
                                            LineChartBarData(
                                              spots: widget.feedbackSummary
                                                  .skillLvlHistory
                                                  .asMap()
                                                  .entries
                                                  .map((entry) => FlSpot(
                                                      entry.key.toDouble(),
                                                      entry.value.toDouble()))
                                                  .toList(),
                                              isCurved: false,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ])));
  }

  Widget _buildCell(String text) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(text)),
    );
  }

  Widget _buildClickableTextCell(String text, int index) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: InkWell(
          child: Text(text),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: FeedbackView(
                    feedback:
                        widget.feedbackSummary.getFeedbackFromIndex(index),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
      String text, int pos, Map<String, List<double>>? list, IconButton? icon) {
    return pos == 2
        ? Column(children: [
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(text,
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                    icon!
                  ],
                )),
            _scrollableTable(list!, true, null)
          ])
        : Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(text,
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold)),
          );
  }

  Widget _scrollableTable(
      Map<String, List<double>> list, bool isSubHeader, int? index) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final itemCount = list.length;
      final cellWidth = itemCount > 0 ? maxWidth / itemCount : maxWidth;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: list.entries.toList().asMap().entries.map((entry) {
            return Container(
                decoration: BoxDecoration(
                    border: isSubHeader
                        ? Border.all(color: Colors.black)
                        : (entry.key !=
                                widget.feedbackSummary.lOsAndRateHistory
                                        .length -
                                    1)
                            ? const Border(
                                right: BorderSide(color: Colors.black))
                            : const Border()),
                width: itemCount > 5 ? 200 : cellWidth,
                child: Center(
                  child: SizedBox(
                    child: Text(isSubHeader
                        ? entry.value.key
                        : (_failureRate)
                            ? '${entry.value.value[index!]}%'
                            : '${(100 - entry.value.value[index!]).toStringAsFixed(2)}%'),
                  ),
                ));
          }).toList(),
        ),
      );
    });
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
    return Column(
      children: [
        TextButton(
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
            style: ButtonStyle(overlayColor:
                WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.transparent;
              }
              return Colors.transparent;
            }), textStyle: WidgetStateProperty.resolveWith<TextStyle>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.hovered)) {
                  return const TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                  );
                }
                return const TextStyle(
                  fontSize: 16,
                );
              },
            )),
            child: const Text('Take assessment again →',
                style: TextStyle(color: ThemeColor.darkgreyTheme))),
        Row(children: [
          Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value ?? false; // Update the checkbox state
              });
            },
          ),
          const Text('exclude mastered learning outcomes?')
        ])
      ],
    );
  }
}
