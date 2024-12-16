import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../Models/LessonModel.dart';
import '../View_Models/AtomicInputMaterialInfoViewModel.dart';
import '../View_Models/InitialAddMaterialsViewModel.dart';
import 'AtomicInputMaterialInfoView.dart';

class InitialAddMaterialsView extends StatelessWidget {
  final LessonModel lesson;

  InitialAddMaterialsView({super.key, required this.lesson}) {
    late List<Color> learningOutcomeColors =
        ThemeColor.generatePastelColors(lesson.learningOutcomes!.length);

    mainLessonTab = SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return Expanded(
              child: AtomicInputMaterialInfoView(
            connector: connect,
            lesson: lesson,
            lessonType: "main",
            learningStyle: learningStyles[index],
            concepts: lesson.learningOutcomes!,
            color: learningOutcomeColors,
          ));
        }),
      ),
    );

    subLessonTab = SingleChildScrollView(
        child: Column(children: [
      const SizedBox(height: 20),
      ListView.separated(
        shrinkWrap:
            true, // Add this to prevent ListView from taking up all available space
        physics:
            const NeverScrollableScrollPhysics(), // Prevent scrolling inside the Column
        itemCount: lesson.learningOutcomes!.length,
        itemBuilder: (context, index1) {
          return Column(children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: learningOutcomeColors[index1]),
                child: Center(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(lesson.learningOutcomes![index1],
                            style: const TextStyle(
                                fontSize: 24,
                                color: ThemeColor.offwhiteTheme))))),
            Row(
              children: [
                ...List.generate(3, (index2) {
                  return Expanded(
                      child: AtomicInputMaterialInfoView(
                          connector: connect,
                          lesson: lesson,
                          lessonType: "sub",
                          learningStyle: learningStyles[index2],
                          concepts: [lesson.learningOutcomes![index1]],
                          color: [learningOutcomeColors[index1]]));
                }),
              ],
            )
          ]);
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 50),
      )
    ]));
  }

  final viewModel = InitialAddMaterialsViewModel();
  final learningStyles = const ["Text", "Visual", "Audio"];
  late final Widget mainLessonTab;
  late final Widget subLessonTab;

  void connect(AtomicInputMaterialViewModel infoModel) {
    viewModel.initialMaterials.add(infoModel);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: viewModel,
        child: Consumer<InitialAddMaterialsViewModel>(
            builder: (context, viewmodel, child) {
          return Column(children: [
            Flexible(
                flex: 10,
                child: DefaultTabController(
                    length: 2,
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const TabBar(
                                tabs: [
                                  Tab(text: 'Main lessons'),
                                  Tab(text: 'Sub lessons'),
                                ],
                              ),
                              Expanded(
                                  child: TabBarView(
                                      children: [mainLessonTab, subLessonTab])),
                            ],
                          ),
                        )))),
            Flexible(
              flex: 1,
              child: Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColor.darkgreyTheme,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 50), // Padding
                      ),
                      child: const Text('Submit',
                          style: TextStyle(
                              color: ThemeColor.offwhiteTheme, fontSize: 21)),
                      onPressed: () async {
                        if (viewModel.validate()) {
                          if (await viewModel.addMultipleMaterials(lesson) &&
                              await viewmodel.confirmSetupComplete(lesson)) {
                            Navigator.pop(context);
                          } else {
                            showMessage(
                                'Error submitting lessons and completing setup',
                                context);
                          }
                        } else {
                          showMessage('Some fields are missing', context);
                        }
                      })),
            ),
            Flexible(
                flex: 1,
                child: Container(
                    decoration:
                        const BoxDecoration(color: ThemeColor.darkgreyTheme),
                    child: const Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Text(
                              "To upload a YouTube video link, go to the YouTube video, click Share, "
                              "click Embed, and copy the link enclosed in \"quotation marks\".",
                              style:
                                  TextStyle(color: ThemeColor.offwhiteTheme)),
                          Text(
                              "When uploading a PDF or mp3 link from a Google drive, change 'view' to 'preview'.",
                              style:
                                  TextStyle(color: ThemeColor.offwhiteTheme)),
                        ]))))
          ]);
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
