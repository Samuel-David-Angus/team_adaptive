import 'dart:math';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'ConceptMapModel.dart';

void main() {
  runApp(MaterialApp(
    home: StaticConceptMapPage(),
  ));
}

class StaticConceptMapPage extends StatelessWidget {
  final Graph graph = Graph();
  final SugiyamaConfiguration builder = SugiyamaConfiguration()
    ..nodeSeparation = 30
    ..levelSeparation = 100
    ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM;

  // CONCEPT MAP EXAMPLE
  final ConceptMapModel conceptMapModel = ConceptMapModel.setAll(
    id: "map1",
    courseID: "course101",
    conceptMap: {
      "ConceptA": [0, 0, 0, 0, 0],
      "ConceptB": [1, 0, 0, 0, 0],
      "@ConceptC": [1, 0, 0, 0, 0],
      "@ConceptD": [0, 1, 1, 0, 0],
      "ConceptE": [0, 0, 0, 1, 0],
    },
    lessonPartitions: {
      "Lesson1": ["ConceptA", "ConceptB"],
      "Lesson2": ["@ConceptC"],
      "Lesson3": ["@ConceptD"],
      "Lesson4": ["ConceptE"],
    },
    maxFailureRates: {
      "ConceptA": 0.2,
      "ConceptB": 0.15,
      "@ConceptC": 0.1,
      "@ConceptD": 0.25,
      "ConceptE": 0.5,
    },
  );

  final Map<String, Color> lessonColors = {};

  StaticConceptMapPage() {
    _assignColorsToLessons();
    _buildGraphFromModel();
  }

  void _assignColorsToLessons() {
    final int n =
        conceptMapModel.lessonPartitions.keys.length; // Number of lessons
    int index = 0;

    conceptMapModel.lessonPartitions.keys.forEach((lesson) {
      double hue =
          (index * 360 / n) % 360; // Spread hues evenly around the color wheel
      int color = HSVColor.fromAHSV(1.0, hue, 0.8, 0.9).toColor().value;

      lessonColors[lesson] = Color(color);
      index++;
    });
  }

  void _buildGraphFromModel() {
    // Add nodes for each concept
    conceptMapModel.conceptMap.forEach((concept, _) {
      graph.addNode(Node.Id(concept));
    });

    // Add edges based on connections between concepts
    for (String concept in conceptMapModel.conceptMap.keys) {
      List<int> connections = conceptMapModel.conceptMap[concept]!;
      for (int i = 0; i < connections.length; i++) {
        if (connections[i] == 1) {
          String prereq = conceptMapModel.conceptOfIndex(i);
          graph.addEdge(Node.Id(prereq), Node.Id(concept));
        }
      }
    }
  }

  Color getNodeColor(String concept) {
    for (var entry in conceptMapModel.lessonPartitions.entries) {
      if (entry.value.contains(concept)) {
        return lessonColors[entry.key] ?? Colors.grey; // Default to grey
      }
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Concept Map'),
      ),
      body: Row(
        children: [
          // Legend Box
          Container(
            width: 150,
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Legend',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ...lessonColors.entries.map((entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: entry.value,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(entry.key),
                        ],
                      ),
                    )),
                SizedBox(height: 10),
                // External Concept Indicator
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text("from another\ncourse"),
                  ],
                ),
              ],
            ),
          ),
          // Graph Viewer
          Expanded(
            child: InteractiveViewer(
              constrained: false,
              boundaryMargin: EdgeInsets.all(50),
              minScale: 0.01,
              maxScale: 5.0,
              child: GraphView(
                graph: graph,
                algorithm: SugiyamaAlgorithm(builder),
                builder: (Node node) {
                  String nodeText = node.key?.value ?? 'Node';
                  Color nodeColor = getNodeColor(nodeText);

                  // Remove '@' from the displayed text if it's an external concept
                  String displayedText = nodeText.startsWith('@')
                      ? nodeText.substring(1)
                      : nodeText;

                  // Calculate the appropriate size based on the text length
                  double minSize =
                      50; // Minimum size to ensure it's not too small
                  double size = max(minSize, 10.0 * displayedText.length);

                  return Container(
                    width: nodeText.startsWith('@') ? size : null,
                    height: nodeText.startsWith('@') ? size : null,
                    padding:
                        nodeText.startsWith('@') ? null : EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: nodeColor,
                      shape: nodeText.startsWith('@')
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                      borderRadius: nodeText.startsWith('@')
                          ? null
                          : BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: FittedBox(
                        child: Text(
                          displayedText,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
