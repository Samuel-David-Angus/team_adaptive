import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/View_Models/ConceptMapViewModel.dart';

class ConceptMapView extends StatelessWidget {
  Course? course;
  final TextEditingController conceptController = TextEditingController();

  ConceptMapView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ConceptMapViewModel>(context, listen: false);
    final Widget view = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50.0),
            const Text(
              "Concept Map",
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
              )
            ),
            const SizedBox(height: 50.0),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3, // Set the desired width
              child: Column(
                children: [
                  if (course == null)
                    ...[
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Concept',
                          border: OutlineInputBorder(),
                        ),
                        controller: conceptController,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              viewModel.addConcept(conceptController.text);
                            },
                            child: const Text("Add Concept"),
                          ),
                          const SizedBox(width: 10),
                          Consumer<ConceptMapViewModel>(
                            builder: (context, viewModel, child) {
                              return viewModel.map != null && viewModel.map!.conceptMap.isNotEmpty
                                  ? // Your existing code here
                                  Container() // Placeholder for the existing code
                                  : Container(); // Placeholder for the existing code
                            },
                          ),
                        ],
                      ),
                    ],
                ],
              ),
            ),
            Consumer<ConceptMapViewModel>(
              builder: (context, viewModel, child) {
                final conceptMap = viewModel.map?.conceptMap;

                if (conceptMap == null || conceptMap.isEmpty) {
                  return const Center(child: Text('No data available'));
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: buildTable(conceptMap, viewModel, course == null),
                  ),
                );
              },
            ),
            const SizedBox(height: 50.0)
          ],
        ),
      ),
    );
    if (course != null) {
      if (viewModel.map == null || viewModel.map!.courseID != course!.id) {
        viewModel.getConceptMap(course!.id!);
      }
      return TemplateView(
          highlighted: SELECTED.NONE,
          topRight: userInfo(context),
          child: view
      );
    }
    viewModel.createConceptMap();
    return view;
  }

  Widget buildTable(Map<String, List<int>>? data, ConceptMapViewModel viewModel, bool canEdit) {

    if (data == null) {
      return const CircularProgressIndicator();
    }
    var keys = data.keys.toList();
    var rows = List.generate(
      data.length,
          (rowIndex) => DataRow(
        cells: [DataCell(Text(keys[rowIndex]))] + List.generate(
              data[keys[rowIndex]]!.length,
              (colIndex) => DataCell(GestureDetector(
                onTap: canEdit ? (){viewModel.setPrerequisite(keys[rowIndex], keys[colIndex]);} : (){},
                child: Text(data[keys[rowIndex]]![colIndex].toString()))),
        ),
      ),
    );
    var columns = [const DataColumn(
        label: Text(''))] + List.generate(
      data.length,
          (index) => DataColumn(
        label: Text(keys[index]),
      ),
    );

    return DataTable(

      columns: columns,
      rows: rows,
    );
  }
}
