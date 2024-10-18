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
        title: Text('Interactive Concept Map'),
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
                    boundaryMargin: EdgeInsets.all(50),
                    minScale: 0.01,
                    maxScale: 5.0,
                    child: GraphView(
                      graph: graph,
                      algorithm: SugiyamaAlgorithm(builder),
                      builder: (Node node) {
                        var nodeText = node.key?.value ?? 'Node';
                        return GestureDetector(
                          onTap: () => onNodeTap(node),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.blue,
                            ),
                            child: Text(
                              nodeText,
                              style: TextStyle(color: Colors.white),
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
      floatingActionButton: FloatingActionButton(
        onPressed: addNode,
        child: Icon(Icons.add),
      ),
    );
  }

  void resetSelection() {
    setState(() {
      selectedNode = null;
      mousePosition = null;
    });
  }

  void addNode() async {
    String? nodeName = await _getNodeNameFromUser();
    if (nodeName != null && nodeName.isNotEmpty) {
      String lessonID = "Lesson_${conceptMapModel.conceptCount + 1}";
      if (conceptMapModel.addLocalLearningOutcome(nodeName, 0.1, lessonID)) {
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
              //PRINT CONCEPT MAP
              for (int i = 0; i < conceptMapModel.conceptCount; i++) {
                String conceptName = conceptMapModel.conceptOfIndex(i);
                debugPrint(conceptName + " prerequisites:");
                List<String> prereqs =
                    conceptMapModel.findDirectPrerequisites(conceptName);
                for (String prereq in prereqs) {
                  debugPrint("\t" + prereq);
                }
              }
              debugPrint("");
              //PRINTED CONCEPT MAP
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

  Future<String?> _getNodeNameFromUser(
      {String prompt = 'Enter node name'}) async {
    TextEditingController controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(prompt),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Node name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
