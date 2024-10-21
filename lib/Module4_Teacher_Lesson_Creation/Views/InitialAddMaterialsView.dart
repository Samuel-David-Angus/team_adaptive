import 'package:flutter/material.dart';

import '../Models/LessonModel.dart';
import '../View_Models/InitialAddMaterialsViewModel.dart';
import '../View_Models/AtomicInputMaterialInfoViewModel.dart';
import 'AtomicInputMaterialInfoView.dart';
import 'package:provider/provider.dart';

class InitialAddMaterialsView extends StatelessWidget {
  final LessonModel lesson;
  InitialAddMaterialsView({super.key, required this.lesson}) {
    mainLessonTab = SingleChildScrollView(
      child: Column(children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return AtomicInputMaterialInfoView(
                connector: connect,
                lesson: lesson,
                lessonType: "main",
                learningStyle: learningStyles[index],
                concepts: lesson.learningOutcomes!);
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        )
      ]),
    );
    subLessonTab = SingleChildScrollView(
      child: Column(children: [
        ListView.separated(
          shrinkWrap:
              true, // Add this to prevent ListView from taking up all available space
          physics:
              const NeverScrollableScrollPhysics(), // Prevent scrolling inside the Column
          itemCount: lesson.learningOutcomes!.length,
          itemBuilder: (context, index1) {
            return Column(
              children: [
                ...List.generate(3, (index2) {
                  return AtomicInputMaterialInfoView(
                    connector: connect,
                    lesson: lesson,
                    lessonType: "sub",
                    learningStyle: learningStyles[index2],
                    concepts: [lesson.learningOutcomes![index1]],
                  );
                }),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        )
      ]),
    );
  }

  final viewModel = InitialAddMaterialsViewModel();
  final learningStyles = const ["Text", "Visual", "Audio"];

  void connect(AtomicInputMaterialViewModel infoModel) {
    viewModel.initialMaterials.add(infoModel);
  }

  late final Widget mainLessonTab;
  late final Widget subLessonTab;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: viewModel,
        child: Consumer<InitialAddMaterialsViewModel>(
            builder: (context, viewmodel, child) {
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(children: [
                      ElevatedButton(
                          child: const Text('Main lessons'),
                          onPressed: () {
                            viewModel.index = 0;
                          }),
                      ElevatedButton(
                          child: const Text('Sub lessons'),
                          onPressed: () {
                            viewModel.index = 1;
                          }),
                      ElevatedButton(
                          child: const Text('Submit lessons'),
                          onPressed: () async {
                            if (viewModel.validate()) {
                              if (await viewModel
                                      .addMultipleMaterials(lesson) &&
                                  await viewmodel
                                      .confirmSetupComplete(lesson)) {
                                Navigator.pop(context);
                              } else {
                                showMessage(
                                    'Error submitting lessons and completing setup',
                                    context);
                              }
                            } else {
                              showMessage('Some fields are missing', context);
                            }
                          }),
                    ]),
                    Expanded(
                        child: IndexedStack(index: viewModel.index, children: [
                      mainLessonTab,
                      subLessonTab,
                    ]))
                  ],
                ),
              ));
        }));
  }
}

void showMessage(String message, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('OOPS!'),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'))
            ]);
      });
}
