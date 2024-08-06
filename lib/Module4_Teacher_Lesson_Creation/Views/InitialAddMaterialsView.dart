import 'package:flutter/material.dart';

import '../../Components/TemplateView.dart';
import '../../Components/TopRightOptions.dart';
import '../Models/LessonModel.dart';
import '../View_Models/InitialAddMaterialsViewModel.dart';
import '../View_Models/AtomicInputMaterialInfoViewModel.dart';
import 'AtomicInputMaterialInfoView.dart';
import 'package:provider/provider.dart';

class InitialAddMaterialsView extends StatelessWidget {
  final LessonModel lesson;
  InitialAddMaterialsView({super.key, required this.lesson}) {
    viewModel.setPrereqs(lesson.courseID!, lesson.concepts!);
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
                concepts: lesson.concepts!);
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        )
      ]),
    );
    subLessonTab = FutureBuilder<List<String>>(
        future: viewModel.prereqs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(children: [
                ListView.separated(
                  shrinkWrap:
                      true, // Add this to prevent ListView from taking up all available space
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevent scrolling inside the Column
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index1) {
                    return Column(
                      children: [
                        ...List.generate(3, (index2) {
                          return AtomicInputMaterialInfoView(
                            connector: connect,
                            lesson: lesson,
                            lessonType: "main",
                            learningStyle: learningStyles[index2],
                            concepts: [snapshot.data![index1]],
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
          } else {
            return const Center(child: Text('No data available'));
          }
        });
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
    return TemplateView(
        highlighted: SELECTED.NONE,
        topRight: userInfo(context),
        child: ChangeNotifierProvider.value(
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
                                  await viewModel.addMultipleMaterials(lesson);
                                  Navigator.pop(context);
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            title: const Text('OOPS!'),
                                            content: const Text(
                                                'some fields are missing.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Ok'))
                                            ]);
                                      });
                                }
                              }),
                        ]),
                        Expanded(
                            child:
                                IndexedStack(index: viewModel.index, children: [
                          mainLessonTab,
                          subLessonTab,
                        ]))
                      ],
                    ),
                  ));
            })));
  }
}
