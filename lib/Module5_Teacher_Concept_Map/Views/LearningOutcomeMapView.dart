import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherAddLearningOutcomesView.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Models/LearningOutcomeModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/View_Models/ConceptMapViewModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Views/SearchExternalLearningOutcomesView.dart';

class LearningOutcomeMapView extends StatefulWidget {
  final String lessonID;
  final String courseID;
  const LearningOutcomeMapView(
      {super.key, required this.lessonID, required this.courseID});

  @override
  State<LearningOutcomeMapView> createState() => _LearningOutcomeMapViewState();
}

class _LearningOutcomeMapViewState extends State<LearningOutcomeMapView>
    with AutomaticKeepAliveClientMixin<LearningOutcomeMapView> {
  final Graph graph = Graph();
  final SugiyamaConfiguration builder = SugiyamaConfiguration()
    ..nodeSeparation = 30
    ..levelSeparation = 100
    ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM;

  Node? selectedNode;
  Node? hoveredNode;
  late final ConceptMapViewModel conceptMapViewModel;

  @override
  void initState() {
    super.initState();
    conceptMapViewModel =
        Provider.of<ConceptMapViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              graph.nodeCount() == 0
                  ? const Text("No learning outcomes yet")
                  : InteractiveViewer(
                      constrained: false,
                      boundaryMargin: const EdgeInsets.all(50),
                      minScale: 1.0,
                      maxScale: 1.0,
                      child: GraphView(
                        graph: graph,
                        algorithm: SugiyamaAlgorithm(builder),
                        builder: (Node node) {
                          String nodeText = node.key?.value ?? 'Node';
                          return MouseRegion(
                            onEnter: (PointerEnterEvent event) {
                              setState(() {
                                hoveredNode = node;
                              });
                            },
                            onExit: (PointerExitEvent event) {
                              setState(() {
                                hoveredNode = null;
                              });
                            },
                            child: GestureDetector(
                              onTap: () => onNodeTap(node),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: (nodeText.startsWith("@"))
                                      ? BorderRadius.circular(10)
                                      : null,
                                  color: setNodeColor(node),
                                ),
                                child: Text(
                                  nodeText,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
              if (selectedNode != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Learning Outcome: ${getNodeValue(selectedNode!)}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                conceptMapViewModel.deleteConcept(
                                    getNodeValue(selectedNode!),
                                    widget.lessonID);
                                graph.removeNode(selectedNode!);
                                selectedNode = null;
                              });
                            },
                            child: const Text("Delete Learning Outcoe")),
                        Row(
                          children: [
                            const Text("Prerequisites: "),
                            ElevatedButton(
                                onPressed: () {
                                  addExternalLOasPrerequisite(
                                      selectedNode!, context);
                                },
                                child: const Text("Add external prerequisite"))
                          ],
                        ),
                        Expanded(
                            child: ListView.builder(
                          itemCount: conceptMapViewModel.map!
                              .findDirectPrerequisites(
                                  getNodeValue(selectedNode!))
                              .length,
                          itemBuilder: (context, index) {
                            final prerequisite = conceptMapViewModel.map!
                                .findDirectPrerequisites(
                                    getNodeValue(selectedNode!))[index];

                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListTile(
                                leading: MouseRegion(
                                  onEnter: (event) {
                                    highlightConnection(
                                        selectedNode!, prerequisite,
                                        highlight: true);
                                  },
                                  onExit: (event) {
                                    highlightConnection(
                                        selectedNode!, prerequisite,
                                        highlight: false);
                                  },
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      deleteConnection(
                                          selectedNode!, prerequisite);
                                    },
                                  ),
                                ),
                                title: Text(prerequisite),
                              ),
                            );
                          },
                        )),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedNode = null;
                            });
                          },
                          child: const Text('Hide'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              String? lO = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: TeacherAddLearningObjectivesView(
                            lessonID: widget.lessonID),
                      ));
              if (lO != null) {
                setState(() {
                  graph.addNode(Node.Id(lO));
                });
              }
            },
            child: const Text("Add learning outcome"))
      ],
    );
  }

  Color setNodeColor(node) {
    if (node == selectedNode) {
      return Colors.green;
    } else if (node == hoveredNode) {
      return Colors.lightBlue;
    }
    return Colors.blue;
  }

  void onNodeTap(Node node) {
    setState(() {
      if (selectedNode == null) {
        selectedNode = node;
      } else {
        if (selectedNode != node) {
          String sourceName = getNodeValue(selectedNode!);
          String targetName = getNodeValue(node);

          if (conceptMapViewModel.setPrerequisite(targetName, sourceName)) {
            graph.addEdge(selectedNode!, node,
                paint: Paint()..color = Colors.black);
          }
        }
        selectedNode = null;
      }
    });
  }

  String getNodeValue(Node node) {
    return node.key!.value;
  }

  void highlightConnection(Node selectedNode, String prerequisite,
      {required bool highlight}) {
    setState(() {
      Node pair = graph.getNodeUsingId(prerequisite);
      graph.getEdgeBetween(pair, selectedNode)!.paint!.color =
          highlight ? Colors.red : Colors.black;
    });
  }

  void deleteConnection(Node selectedNode, String prerequisite) {
    String selectedNodeValue = getNodeValue(selectedNode);
    Node pair = graph.getNodeUsingId(prerequisite);
    if (conceptMapViewModel.map!
                .areConnected(selectedNodeValue, prerequisite) ==
            1 &&
        conceptMapViewModel.setPrerequisite(selectedNodeValue, prerequisite)) {
      setState(() {
        graph.removeEdge(graph.getEdgeBetween(pair, selectedNode)!);
      });
    }
  }

  void deleteNode(Node node) {
    String lO = getNodeValue(node);
    if (conceptMapViewModel.deleteConcept(lO, widget.lessonID)) {
      setState(() {
        graph.removeNode(node);
      });
    }
  }

  void addExternalLOasPrerequisite(
      Node selectedNode, BuildContext context) async {
    LearningOutcomeModel? externalLO = await showDialog<LearningOutcomeModel>(
        context: context,
        builder: (context) => AlertDialog(
              content: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height,
                  child: SearchExternalLearningOutcomesView(
                      lessonID: widget.lessonID)),
            ));
    if (externalLO != null) {
      String lO = externalLO.learningOutcome;
      if (externalLO.courseID != widget.courseID) {
        lO = "@$lO";
        conceptMapViewModel.map!
            .addExternalLearningOutcome(lO, widget.lessonID);
      }
      conceptMapViewModel.setPrerequisite(getNodeValue(selectedNode), lO);
      setState(() {
        Node newNode = Node.Id(lO);
        graph.addNode(newNode);
        graph.addEdge(newNode, selectedNode);
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
