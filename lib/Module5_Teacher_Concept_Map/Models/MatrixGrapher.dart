import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'ConceptMapModel.dart';

void main() {
  runApp(MaterialApp(
    home: InteractiveDirectedGraphPage(),
  ));
}

class InteractiveDirectedGraphPage extends StatefulWidget {
  @override
  _InteractiveDirectedGraphPageState createState() =>
      _InteractiveDirectedGraphPageState();
}

class _InteractiveDirectedGraphPageState
    extends State<InteractiveDirectedGraphPage> {
  final Graph graph = Graph();
  final SugiyamaConfiguration builder = SugiyamaConfiguration()
    ..nodeSeparation = 30
    ..levelSeparation = 100
    ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM;

  final ConceptMapModel conceptMapModel = ConceptMapModel.setAll(
    id: "defaultID",
    courseID: "defaultCourse",
    conceptMap: {},
    lessonPartitions: {},
    maxFailureRates: {},
  );

  Node? selectedNode;
  Offset? mousePosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Concept Map Maker'),
      ),
      body: conceptMapModel.conceptCount > 0
          ? GestureDetector(
              onPanUpdate: (details) {
                if (selectedNode != null) {
                  setState(() {
                    mousePosition = details.localPosition;
                  });
                }
              },
              onTap: resetSelection,
              child: Stack(
                children: [
                  InteractiveViewer(
                    constrained: false,
                    boundaryMargin: const EdgeInsets.all(50),
                    minScale: 0.01,
                    maxScale: 5.0,
                    child: GraphView(
                      graph: graph,
                      algorithm: SugiyamaAlgorithm(builder),
                      builder: (Node node) {
                        String nodeText = _getNodeDisplayName(node.key?.value);

                        return GestureDetector(
                          onTap: () => onNodeTap(node),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: _isExternalConcept(node.key?.value)
                                  ? BoxShape.circle
                                  : BoxShape.rectangle,
                              color: Colors.blue,
                              borderRadius: _isExternalConcept(node.key?.value)
                                  ? null
                                  : BorderRadius.circular(4),
                            ),
                            child: Text(
                              nodeText,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (selectedNode != null && mousePosition != null)
                    CustomPaint(
                      painter: LinePainter(
                        start: getNodePosition(selectedNode!) ?? Offset.zero,
                        end: mousePosition!,
                      ),
                    ),
                ],
              ),
            )
          : const Center(child: Text("Add nodes to start.")),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "local",
            onPressed: () => addLocalLearningOutcome(),
            child: const Icon(Icons.add),
            tooltip: 'Add Local Learning Outcome',
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "external",
            onPressed: () => addExternalLearningOutcome(),
            child: const Icon(Icons.link),
            tooltip: 'Add Learning Outcome From Another Course',
          ),
        ],
      ),
    );
  }

  void resetSelection() {
    setState(() {
      selectedNode = null;
      mousePosition = null;
    });
  }

  Future<void> addLocalLearningOutcome() async {
    final result = await _getLocalLearningOutcomeFromUser();
    if (result != null) {
      final nodeName = result['conceptName']!;
      final maxFailureRate = double.parse(result['maxFailureRate']!);
      final lessonID = result['lessonID']!;

      if (conceptMapModel.addLocalLearningOutcome(
          nodeName, maxFailureRate, lessonID)) {
        setState(() {
          Node newNode = Node.Id(nodeName);
          graph.addNode(newNode);
        });
      }
    }
  }

  Future<void> addExternalLearningOutcome() async {
    final result = await _getExternalLearningOutcomeFromUser();
    if (result != null) {
      final nodeName = '@${result['conceptName']!}';
      final lessonID = result['lessonID']!;

      if (conceptMapModel.addExternalLearningOutcome(nodeName, lessonID)) {
        setState(() {
          Node newNode = Node.Id(nodeName);
          graph.addNode(newNode);
        });
      }
    }
  }

  void onNodeTap(Node node) {
    setState(() {
      if (selectedNode == null) {
        selectedNode = node;
      } else {
        if (selectedNode != node) {
          String sourceName = selectedNode!.key?.value;
          String targetName = node.key?.value;

          if (sourceName != null && targetName != null) {
            if (conceptMapModel.setPrerequisite(targetName, sourceName)) {
              graph.addEdge(selectedNode!, node);

              // PRINT CONCEPT MAP
              for (int i = 0; i < conceptMapModel.conceptCount; i++) {
                String conceptName = conceptMapModel.conceptOfIndex(i);
                debugPrint('$conceptName prerequisites:');
                List<String> prereqs =
                    conceptMapModel.findDirectPrerequisites(conceptName);
                for (String prereq in prereqs) {
                  debugPrint('\t$prereq');
                }
              }
              debugPrint('');
              // PRINTED CONCEPT MAP
            }
          }
          resetSelection();
        } else {
          resetSelection();
        }
      }
    });
  }

  Offset? getNodePosition(Node node) {
    RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    return renderBox?.localToGlobal(Offset.zero);
  }

  Future<Map<String, String>?> _getLocalLearningOutcomeFromUser() async {
    final conceptNameController = TextEditingController();
    final maxFailureRateController = TextEditingController();
    final lessonIDController = TextEditingController();

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Local Learning Outcome'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: conceptNameController,
                decoration: const InputDecoration(hintText: 'Concept Name'),
              ),
              TextField(
                controller: maxFailureRateController,
                decoration: const InputDecoration(hintText: 'Max Failure Rate'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: lessonIDController,
                decoration: const InputDecoration(hintText: 'Lesson ID'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'conceptName': conceptNameController.text,
                  'maxFailureRate': maxFailureRateController.text,
                  'lessonID': lessonIDController.text,
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, String>?> _getExternalLearningOutcomeFromUser() async {
    final conceptNameController = TextEditingController();
    final lessonIDController = TextEditingController();

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add External Learning Outcome'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: conceptNameController,
                decoration: const InputDecoration(hintText: 'Concept Name'),
              ),
              TextField(
                controller: lessonIDController,
                decoration: const InputDecoration(hintText: 'Lesson ID'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'conceptName': conceptNameController.text,
                  'lessonID': lessonIDController.text,
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _getNodeDisplayName(String? nodeName) {
    return nodeName?.replaceAll('@', '') ?? 'Node';
  }

  bool _isExternalConcept(String? nodeName) {
    return nodeName != null && nodeName.startsWith('@');
  }
}

class LinePainter extends CustomPainter {
  final Offset start;
  final Offset end;

  LinePainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
