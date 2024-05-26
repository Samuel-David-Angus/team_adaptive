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
    final viewModel = Provider.of<ConceptMapViewModel>(context);
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
              ElevatedButton(
                  onPressed: (){
                    viewModel.addConcept(conceptController.text);
                  },
                  child: Text("Add Concept")),
              buildTable(viewModel.map!.conceptMap!),
              ElevatedButton(
                  onPressed: (){

                  },
                  child: Text("Save")),
            ],
          ),
        ));
  }

  Widget buildTable(Map<String, List<int>> data) {
    List<TableRow> rows = [];

    // Add the header row
    List<Widget> headerRow = [TableCell(child: SizedBox())]; // Empty cell for corner
    data.keys.forEach((key) {
      headerRow.add(TableCell(child: Center(child: Text(key))));
    });
    rows.add(TableRow(children: headerRow));

    // Add data rows
    data.forEach((key, value) {
      List<Widget> rowData = [TableCell(child: Center(child: Text(key)))];
      value.forEach((element) {
        rowData.add(TableCell(child: Center(child: Text(element.toString()))));
      });
      rows.add(TableRow(children: rowData));
    });

    return Table(
      border: TableBorder.all(),
      children: rows,
    );
  }
}
