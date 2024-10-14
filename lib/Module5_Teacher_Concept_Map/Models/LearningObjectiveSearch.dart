import 'package:flutter/material.dart';
import 'package:characters/characters.dart'; // For handling complex Unicode strings
import 'ConceptMapModel.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Concept Map Browser',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ConceptMapBrowserPage(),
    );
  }
}

class ConceptMapBrowserPage extends StatefulWidget {
  const ConceptMapBrowserPage({super.key});

  @override
  _ConceptMapBrowserPageState createState() => _ConceptMapBrowserPageState();
}

class _ConceptMapBrowserPageState extends State<ConceptMapBrowserPage> {
  final ConceptMapModel _conceptMap = ConceptMapModel.setAll(
    courseID: 'exampleCourseID',
    // EXAMPLE WITH NETWORKING CONCEPTS
    conceptMap: {
      'Introduction to Networking': [],
      'Understanding TCP/IP': [],
      'Routing Fundamentals': [],
      'Subnetting Made Easy': [],
      'Advanced Switching Concepts': [],
    },
  );

  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  void _searchConcepts() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      _searchResults = _sortConceptsByRelevance(query);
    });
  }

  List<String> _sortConceptsByRelevance(String query) {
    List<String> concepts = _conceptMap.conceptMap.keys.toList();

    // Compute similarity scores for all concepts
    List<MapEntry<String, double>> scoredConcepts = concepts.map((concept) {
      double similarity = _calculateTotalSimilarity(query, concept);

      // Debug the matching process
      debugPrint(
          'Query: "$query", Concept: "$concept", Similarity: $similarity');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Concept Map Browser'),
      ),
      body: Padding(
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
                  onPressed: _searchConcepts,
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
                    title: Text(_searchResults[index]),
                    onTap: () {
                      _showConceptDetails(context, _searchResults[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConceptDetails(BuildContext context, String concept) {
    List<String> directPrereqs = _conceptMap.findDirectPrerequisites(concept);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(concept),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Direct Prerequisites:'),
              const SizedBox(height: 8.0),
              ...directPrereqs.map((prereq) => Text(prereq)).toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
