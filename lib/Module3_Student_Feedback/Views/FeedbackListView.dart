import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Views/FeedbackView.dart';

import '../ViewModels/FeedbackViewModel.dart';


class FeedbackListView extends StatelessWidget {
  const FeedbackListView({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<FeedbackViewModel>(context, listen: false);
    return TemplateView(highlighted: SELECTED.NONE, topRight: userInfo(context), child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<FeedbackModel>?>(
            future: viewModel.getUserFeedbacks(),
            builder: (BuildContext context, AsyncSnapshot<List<FeedbackModel>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                var feedbackList = snapshot.data!;
                if (feedbackList.isEmpty) {
                  return const Center(
                    child: Text('No feedback available.'),
                  );
                }
                return ListView.builder(
                  itemCount: feedbackList.length,
                  itemBuilder: (context, index) {
                    var feedback = feedbackList[index];
                    return Card(
                      elevation: 4.0, // Elevation gives a shadow effect to the card
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListTile(
                        title: Text(feedback.feedbackTitle),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackView(feedback: feedbackList[index],)));
                                  },
                                  child: const Text('View'))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No feedback found.'),
                );
              }
            })
    ));
  }
}
