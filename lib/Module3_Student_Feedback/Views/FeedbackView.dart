import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module3_Student_Assessment/Models/AssessmentModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/ViewModels/FeedbackViewModel.dart';

import '../Models/FeedbackModel.dart';

class FeedbackView extends StatelessWidget {
  final AssessmentModel assessment;
  late Future<bool> successfulFeedbackGenerated;
  bool justInitialized = true;
  FeedbackView({super.key, required this.assessment});


  @override
  Widget build(BuildContext context) {
    final FeedbackViewModel viewModel = Provider.of<FeedbackViewModel>(context);
    if (justInitialized) {
      justInitialized = false;
      successfulFeedbackGenerated = viewModel.createFeedback(assessment);
    }
    return FutureBuilder(
        future: successfulFeedbackGenerated,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator(),);
      } else if (snapshot.hasError) {
        return Center(child: Text('Error occurred: ${snapshot.error}'),);
      } else if (snapshot.hasData && snapshot.data != null && snapshot.data!) {
        Map<String, double> conceptsAndFailureRates = viewModel.feedback.calculateLessonConceptFailureRates();
        return Column(
          children: [
            const Text('Feedback'),
            Table(
              children: conceptsAndFailureRates.entries.map<TableRow>(
                  (entry) {
                    return TableRow(
                      children: [
                        Text(entry.key),
                        Text(entry.value.toString())
                      ]
                    );
                  }
              ).toList(),
            )
          ],
        );
      } else {
        return const Center(child: Text('Unable to load feedback'));
      }
    );
  }
}
