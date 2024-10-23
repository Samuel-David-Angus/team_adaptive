import 'dart:js_interop';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackSummaryModel.dart';
import 'package:team_adaptive/Module7_Teacher_Dashboard/Services/TeacherDashboardService.dart';

class LessonDashboardViewModel extends ChangeNotifier {
  late List<FeedbackSummaryModel> feedbackSummaries;
  late List<FeedbackSummaryModel> filteredListByAttemptNumber;
  int attemptNumber = 1;
  int maxAttempt = 0;

  int get numberOfStudents => filteredListByAttemptNumber.length;

  Future<void> getFeedbackSummaries(String courseID, String lessonID) async {
    feedbackSummaries = await TeacherDashboardService()
        .getFeedbackSummariesByLessonAndCourse(courseID, lessonID);
    filteredListByAttemptNumber = feedbackSummaries;

    if (feedbackSummaries.isNotEmpty) {
      maxAttempt = feedbackSummaries
          .reduce((a, b) => a.dateHistory.length > b.dateHistory.length ? a : b)
          .dateHistory
          .length;
    }
  }

  void setAttemptNumber(int value) {
    attemptNumber = value;
    _filterBasedOnAttemptNumber();
    notifyListeners();
  }

  void _filterBasedOnAttemptNumber() {
    filteredListByAttemptNumber = feedbackSummaries
        .where((feedbackSummary) =>
            feedbackSummary.dateHistory.length >= attemptNumber)
        .toList();
  }

  List<PieChartSectionData> getWeakConceptsPieSections() {
    Map<String, int> conceptAndCount = {};
    for (FeedbackSummaryModel feedbackSummaryModel
        in filteredListByAttemptNumber) {
      List<String> weakConcepts =
          feedbackSummaryModel.weakConceptsHistory[attemptNumber - 1]!;
      for (String weakConcept in weakConcepts) {
        if (!conceptAndCount.containsKey(weakConcept)) {
          conceptAndCount[weakConcept] = 0;
        }
        conceptAndCount[weakConcept] = conceptAndCount[weakConcept]! + 1;
      }
    }
    List<Color> colors = generateColorSequence(conceptAndCount.length);
    int index = 0;
    int totalCount = conceptAndCount.values.reduce((a, b) => a + b);
    List<PieChartSectionData> sections = [];
    conceptAndCount.forEach((concept, count) {
      sections.add(
        PieChartSectionData(
          color: colors[index++],
          value: count.toDouble(),
          title:
              '$concept (${(count / totalCount * 100).toStringAsFixed(1)}%)', // Display percentage
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });

    return sections;
  }

  List<PieChartSectionData> getLearningStylesPieSections() {
    Map<String, int> styleAndCount = {};
    for (FeedbackSummaryModel feedbackSummaryModel
        in filteredListByAttemptNumber) {
      String learningStyle =
          feedbackSummaryModel.learningStyleHistory[attemptNumber - 1];
      if (!styleAndCount.containsKey(learningStyle)) {
        styleAndCount[learningStyle] = 0;
      }
      styleAndCount[learningStyle] = styleAndCount[learningStyle]! + 1;
    }
    List<Color> colors = generateColorSequence(styleAndCount.length);
    int index = 0;
    int totalCount = styleAndCount.values.reduce((a, b) => a + b);
    List<PieChartSectionData> sections = [];
    styleAndCount.forEach((learningStyle, count) {
      sections.add(
        PieChartSectionData(
          color: colors[index++],
          value: count.toDouble(),
          title:
              '$learningStyle (${(count / totalCount * 100).toStringAsFixed(1)}%)', // Display percentage
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });

    return sections;
  }

  List<BarChartGroupData> getSkillLvlBarChartData() {
    Map<int, int> skillLvlAndCount = {for (int i = 0; i < 11; i++) i: 0};
    for (FeedbackSummaryModel feedbackSummaryModel
        in filteredListByAttemptNumber) {
      int skillLvl = feedbackSummaryModel.skillLvlHistory[attemptNumber - 1];
      skillLvlAndCount[skillLvl] = skillLvlAndCount[skillLvl]! + 1;
    }
    int index = 0;
    List<Color> colors = generateColorSequence(skillLvlAndCount.length);
    return skillLvlAndCount.entries.map((entry) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: colors[index++],
            width: 30,
          ),
        ],
      );
    }).toList();
  }
}

List<Color> generateColorSequence(int numberOfColors) {
  List<Color> colors = [];
  for (int index = 0; index < numberOfColors; index++) {
    double hue = (index * 360 / numberOfColors) %
        360; // Spread hues evenly around the color wheel
    Color color = HSVColor.fromAHSV(1.0, hue, 0.8, 0.9).toColor();
    colors.add(color);
  }
  return colors;
}
