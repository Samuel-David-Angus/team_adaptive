import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackSummaryModel.dart';

import '../ViewModels/FeedbackViewModel.dart';

class FeedbackListView extends StatelessWidget {
  final String? userID;
  const FeedbackListView({super.key, this.userID});

  @override
  Widget build(BuildContext context) {
    var authUserInfo = Provider.of<AuthServices>(context).userInfo;
    if (authUserInfo == null && userID == null) {
      return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text("Please Login to see your feedbacks")));
    }
    var viewModel = Provider.of<FeedbackViewModel>(context, listen: false);
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<FeedbackSummaryModel>?>(
            future: viewModel.getUserFeedbacks(userID: userID),
            builder: (BuildContext context,
                AsyncSnapshot<List<FeedbackSummaryModel>?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                var feedbackList = snapshot.data!;
                if (feedbackList.isEmpty) {
                  return const Center(
                    child: Text('No feedback available.'),
                  );
                }
                return Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          GoRouter.of(context)
                              .go('/personal-credential-search');
                        },
                        child: const Text("Check progress")),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Feedbacks"),
                    Expanded(
                      child: ListView.builder(
                        itemCount: feedbackList.length,
                        itemBuilder: (context, index) {
                          var feedback = feedbackList[index];
                          return Card(
                            elevation:
                                4.0, // Elevation gives a shadow effect to the card
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: ListTile(
                              title: Text(feedback.title),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          GoRouter.of(context).go(
                                              '/feedbacks/${feedback.id}',
                                              extra: feedback);
                                        },
                                        child: const Text('View'))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text('No feedback found.'),
                );
              }
            }));
  }
}
