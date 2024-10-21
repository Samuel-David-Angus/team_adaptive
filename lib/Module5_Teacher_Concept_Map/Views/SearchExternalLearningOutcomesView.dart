import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Views/AtomicLOFeedbackView.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/LearningOutcomeModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/View_Models/ConceptMapViewModel.dart';

class SearchExternalLearningOutcomesView extends StatefulWidget {
  final String? lessonID;
  final String? studentID;
  const SearchExternalLearningOutcomesView(
      {super.key, required this.lessonID, this.studentID});

  @override
  SearchExternalLearningOutcomesViewState createState() =>
      SearchExternalLearningOutcomesViewState();
}

class SearchExternalLearningOutcomesViewState
    extends State<SearchExternalLearningOutcomesView> {
  late final Future<List<LearningOutcomeModel>> lOs;
  final TextEditingController _searchController = TextEditingController();
  List<LearningOutcomeModel> _searchResults = [];

  @override
  void initState() {
    super.initState();
    ConceptMapViewModel cviewModel =
        Provider.of<ConceptMapViewModel>(context, listen: false);
    lOs = widget.lessonID != null
        ? cviewModel.getExternalLearningOutcomes(widget.lessonID!)
        : cviewModel.getAllLearningOutcomes();
  }

  void _searchConcepts(List<LearningOutcomeModel> list) {
    setState(() {
      String query = _searchController.text.toLowerCase();
      _searchResults = _sortConceptsByRelevance(query, list);
    });
  }

  List<LearningOutcomeModel> _sortConceptsByRelevance(
      String query, List<LearningOutcomeModel> lOs) {
    // Compute similarity scores for all concepts
    List<MapEntry<LearningOutcomeModel, double>> scoredConcepts =
        lOs.map((concept) {
      double similarity =
          _calculateTotalSimilarity(query, concept.learningOutcome);

      // Debug the matching process
      // debugPrint(
      //     'Query: "$query", Concept: "$concept", Similarity: $similarity');
      return MapEntry(concept, similarity);
    }).toList();

    // Sort concepts by their similarity scores in descending order
    scoredConcepts.sort((a, b) => b.value.compareTo(a.value));

    // Extract the sorted concept names
    return scoredConcepts.map((entry) => entry.key).toList();
  }

  double _calculateTotalSimilarity(String query, String concept) {
    List<String> queryWords = query.split(RegExp(r'\s+'));
    List<String> conceptWords = concept.split(RegExp(r'\s+'));

    double totalScore = 0.0;

    for (String qWord in queryWords) {
      double maxSimilarity = 0.0;
      for (String cWord in conceptWords) {
        double similarity = _stringSimilarity(qWord, cWord);
        if (similarity > maxSimilarity) {
          maxSimilarity = similarity;
        }
      }
      totalScore += maxSimilarity;
    }

    return totalScore;
  }

  double _stringSimilarity(String s1, String s2) {
    int distance = _levenshteinDistance(s1, s2);
    int maxLength = s1.length > s2.length ? s1.length : s2.length;

    // Handle edge case where both strings are empty
    if (maxLength == 0) return 1.0;

    return 1.0 - (distance / maxLength);
  }

  int _levenshteinDistance(String s1, String s2) {
    List<List<int>> dp = List.generate(
      s1.length + 1,
      (i) => List<int>.filled(s2.length + 1, 0),
    );

    for (int i = 0; i <= s1.length; i++) {
      for (int j = 0; j <= s2.length; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 +
              min(
                dp[i - 1][j], // Deletion
                min(
                    dp[i][j - 1], // Insertion
                    dp[i - 1][j - 1]), // Substitution
              ) as int;
        }
      }
    }

    return dp[s1.length][s2.length];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LearningOutcomeModel>>(
      future: lOs, // Your async function to fetch concepts
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No concepts found.'));
        } else {
          List<LearningOutcomeModel> searchResults =
              snapshot.data!; // Fetched data
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          labelText: 'Search Concepts',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        _searchConcepts(searchResults);
                      },
                      child: const Text('Search'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_searchResults[index].learningOutcome),
                        onTap: () {
                          if (widget.lessonID != null) {
                            Navigator.of(context).pop(_searchResults[index]);
                          } else {
                            print(widget.studentID);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: AtomicLOFeedbackView(
                                      learningOutcome:
                                          _searchResults[index].learningOutcome,
                                      userID: widget.studentID == null
                                          ? AuthServices().userInfo!.id!
                                          : widget.studentID!,
                                    ),
                                  );
                                });
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  // void _showConceptDetails(BuildContext context, String concept) {
  //   List<String> directPrereqs = _conceptMap.findDirectPrerequisites(concept);

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(concept),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text('Direct Prerequisites:'),
  //             const SizedBox(height: 8.0),
  //             ...directPrereqs.map((prereq) => Text(prereq)).toList(),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
