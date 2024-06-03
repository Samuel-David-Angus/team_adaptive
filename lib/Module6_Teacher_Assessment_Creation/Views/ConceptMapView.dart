import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/View_Models/ConceptMapViewModel.dart';

class ConceptMapView extends StatelessWidget {
  Course course;
  final TextEditingController conceptController = TextEditingController();

  ConceptMapView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ConceptMapViewModel>(context, listen: false);
    if (viewModel.map == null || viewModel.map!.courseID != course.id) {
      viewModel.getConceptMap(course.id!);
    }
    return TemplateView(
        highlighted: SELECTED.NONE,
        topRight: userInfo(context),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Concept Map"),
              const SizedBox(height: 10,),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Concept',
                  border: OutlineInputBorder()
                ),
                controller: conceptController,
              ),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: (){
                        viewModel.addConcept(conceptController.text);
                      },
                      child: Text("Add Concept")),
                  const SizedBox(width: 10,),
                  Consumer<ConceptMapViewModel>(
                      builder: (context, viewModel, child) {
                        return viewModel.map != null && viewModel.map!.conceptMap!.length > 0 ?
                        PopupMenuButton<String>(
                          child: const Text("Delete Concept"),
                            itemBuilder: (BuildContext context) {
                              Map<String, List<int>> cmap = viewModel.map!.conceptMap!;
                              return List.generate(
                                  cmap.length,
                                  (index) {
                                    String val = cmap!.keys!.toList()[index];
                                    return PopupMenuItem(
                                        value: val,
                                        child: Text(val));
                                  }
                              );
                            },
                          onSelected: (String val) {
                              viewModel.deleteConcept(val);
                          },
                        )
                            : Text('No concepts to delete');
                      }
                  )
                ]
              ),

              Consumer<ConceptMapViewModel>(
                builder: (context, viewModel, child) {
                  final conceptMap = viewModel.map?.conceptMap;

                  if (conceptMap == null || conceptMap.isEmpty) {
                    return Center(child: Text('No data available'));
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: buildTable(conceptMap, viewModel),
                    ),
                  );
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    if(await viewModel.saveEdits()) {
                      print("Saved successfully");
                    } else {
                      print("Not saved");
                    }
                  },
                  child: Text("Save")),
            ],
          ),
        ));
  }

  Widget buildTable(Map<String, List<int>>? data, ConceptMapViewModel viewModel) {

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
                onTap: (){viewModel.setPrerequisite(keys[rowIndex], keys[colIndex]);},
                child: Text(data[keys[rowIndex]]![colIndex].toString()))),
        ),
      ),
    );
    var columns = [DataColumn(
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
