import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../Models/LessonModel.dart';
import '../View_Models/AtomicInputMaterialInfoViewModel.dart';
import '../View_Models/InitialAddMaterialsViewModel.dart';
import 'AtomicInputMaterialInfoView.dart';

class InitialAddMaterialsView extends StatefulWidget {
  final LessonModel lesson;

  const InitialAddMaterialsView({super.key, required this.lesson});

  @override
  _InitialAddMaterialsViewState createState() =>
      _InitialAddMaterialsViewState();
}

class _InitialAddMaterialsViewState extends State<InitialAddMaterialsView> with AutomaticKeepAliveClientMixin {
  late final InitialAddMaterialsViewModel viewModel;
  late final List<Color> learningOutcomeColors;
  late final Widget mainLessonTab;
  late final Widget subLessonTab;

  final learningStyles = const ["Text", "Visual", "Audio"];

  @override
  void initState() {
    super.initState();

    viewModel = InitialAddMaterialsViewModel();
    learningOutcomeColors =
        ThemeColor.generatePastelColors(widget.lesson.learningOutcomes!.length);

    mainLessonTab = _buildMainLessonTab();
    subLessonTab = _buildSubLessonTab();
  }

  Widget _buildMainLessonTab() {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return Expanded(
            child: AtomicInputMaterialInfoView(
              connector: connect,
              lesson: widget.lesson,
              lessonType: "main",
              learningStyle: learningStyles[index],
              concepts: widget.lesson.learningOutcomes!,
              color: learningOutcomeColors,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSubLessonTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.lesson.learningOutcomes!.length,
            itemBuilder: (context, index1) {
              return Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: learningOutcomeColors[index1],
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          widget.lesson.learningOutcomes![index1],
                          style: const TextStyle(
                              fontSize: 24, color: ThemeColor.offwhiteTheme),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ...List.generate(3, (index2) {
                        return Expanded(
                          child: AtomicInputMaterialInfoView(
                            connector: connect,
                            lesson: widget.lesson,
                            lessonType: "sub",
                            learningStyle: learningStyles[index2],
                            concepts: [widget.lesson.learningOutcomes![index1]],
                            color: [learningOutcomeColors[index1]],
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 50),
          )
        ],
      ),
    );
  }

  void connect(AtomicInputMaterialViewModel infoModel) {
    viewModel.initialMaterials.add(infoModel);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<InitialAddMaterialsViewModel>(
        builder: (context, viewmodel, child) {
          return Column(
            children: [
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
                            children: [
                              SingleChildScrollView(
                                key: const PageStorageKey('mainTab'),
                                child: mainLessonTab,
                              ),
                              SingleChildScrollView(
                                key: const PageStorageKey('subTab'),
                                child: subLessonTab,
                              ),
                            ],
                          )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColor.darkgreyTheme,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 50),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          color: ThemeColor.offwhiteTheme, fontSize: 21),
                    ),
                    onPressed: () async {
                      if (viewModel.validate()) {
                        if (await viewModel
                                .addMultipleMaterials(widget.lesson) &&
                            await viewmodel
                                .confirmSetupComplete(widget.lesson)) {
                          // Navigator.pop(context);
                          GoRouter.of(context).go("/courses/${widget.lesson.courseID}/lessons");
                        } else {
                          showMessage(
                              'Error submitting lessons and completing setup',
                              context);
                        }
                      } else {
                        showMessage('Some fields are missing', context);
                      }
                    },
                  ),
                ),
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
                          style: TextStyle(color: ThemeColor.offwhiteTheme),
                        ),
                        Text(
                          "When uploading a PDF or mp3 link from a Google drive, change 'view' to 'preview'.",
                          style: TextStyle(color: ThemeColor.offwhiteTheme),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
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
