import 'package:flutter/material.dart';
import 'ConceptMapModel.dart';
import 'package:collection/collection.dart'; // For similarity sorting (optional)

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
  // EXAMPLE WITH NETWORKING CONCEPTS
  final ConceptMapModel _conceptMap = ConceptMapModel.setAll(
    courseID: 'exampleCourseID',
    conceptMap: {
      'Networking': [],
      'TCP/IP': [],
      'Routing': [],
      'Subnetting': [],
      'Switching': [],
      // Add more example concepts here
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

    // Sort all concepts by similarity to the query
    concepts.sort((a, b) {
      double similarityA = _calculateStringSimilarity(query, a.toLowerCase());
      double similarityB = _calculateStringSimilarity(query, b.toLowerCase());
      return similarityB
          .compareTo(similarityA); // Sort in descending order of similarity
    });

    return concepts;
  }

  double _calculateStringSimilarity(String query, String concept) {
    // Use Jaccard similarity for example purposes (simple calculation)
    Set<String> querySet = query.split('').toSet();
    Set<String> conceptSet = concept.split('').toSet();

    int intersectionSize = querySet.intersection(conceptSet).length;
    int unionSize = querySet.union(conceptSet).length;

    return intersectionSize / unionSize; // Jaccard similarity index
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
