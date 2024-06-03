import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/View_Models/SelectLearningStyleViewModel.dart';

class TeacherSelectLearningStyleView extends StatelessWidget {
  const TeacherSelectLearningStyleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectLearningStyleViewModel>(
        builder: (context, viewModel, child) {
          return AlertDialog(
            title: Text('Select Options'),
            content: SingleChildScrollView(
              child: ListBody(
                children: viewModel.learningStyles!.map((item) {
                  return CheckboxListTile(
                    title: Text(item),
                    value: viewModel.selectedStyle == item,
                    onChanged: (bool? checked) {
                      if (checked == true) {
                        viewModel.setStyle(item);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  viewModel.reset();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  String result = viewModel.selectedStyle;
                  viewModel.reset();
                  Navigator.of(context).pop(result);
                },
              ),
            ],
          );
        }
    );
  }
}
