import 'package:flutter/material.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../Models/LessonModel.dart';
import '../View_Models/AtomicInputMaterialInfoViewModel.dart';

class AtomicInputMaterialInfoView extends StatefulWidget {
  final LessonModel lesson;
  final void Function(AtomicInputMaterialViewModel) connector;
  final String lessonType;
  final List<String> concepts;
  final String learningStyle;
  final List<Color> color;

  const AtomicInputMaterialInfoView(
      {super.key,
      required this.lesson,
      required this.connector,
      required this.lessonType,
      required this.concepts,
      required this.learningStyle,
      required this.color});
  @override
  State<AtomicInputMaterialInfoView> createState() =>
      _AtomicInputMaterialInfoViewState();
}

class _AtomicInputMaterialInfoViewState
    extends State<AtomicInputMaterialInfoView> {
  final viewModel = AtomicInputMaterialViewModel();
  bool isUploadingFile = true;

  @override
  void initState() {
    super.initState();
    viewModel.type = widget.lessonType;
    viewModel.concepts = widget.concepts;
    viewModel.learningStyle = widget.learningStyle;
    widget.connector(viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double parentWidth = constraints.maxWidth;

        return Container(
            height: widget.lessonType == 'main' ? 600 : 300,
            width: parentWidth * 0.24,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                  width: 3,
                  color: widget.lessonType == 'main'
                      ? ThemeColor.darkgreyTheme
                      : widget.color[0]),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: widget.lessonType == 'main'
                  ? ThemeColor.offwhiteTheme
                  : Colors.transparent,
            ),
            child: SingleChildScrollView(
              // scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Learning Style: ${widget.learningStyle}',
                      style: const TextStyle(
                          fontSize: 24, color: ThemeColor.darkgreyTheme)),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        fillColor: ThemeColor.offwhiteTheme,
                        border: OutlineInputBorder(),
                        hintText: 'Title'),
                    controller: viewModel.titleController,
                    style: const TextStyle(
                      color: ThemeColor.darkgreyTheme, // Change text color here
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isUploadingFile
                              ? Icons.toggle_on
                              : Icons.toggle_off, // Toggle between icons
                          size: 50.0,
                          color: isUploadingFile
                              ? widget.lessonType == 'main'
                                  ? ThemeColor.darkgreyTheme
                                  : widget.color[0]
                              : Colors.grey, // Toggle colors
                        ),
                        onPressed: () {
                          setState(() {
                            isUploadingFile = !isUploadingFile;
                            viewModel.linkController.clear();
                            viewModel.fileBytes = null;
                            viewModel.fileName = null; // Toggle the state
                          });
                        },
                      ),
                      Text(
                          isUploadingFile ? "Uploading file" : "Uploading link",
                          style:
                              const TextStyle(color: ThemeColor.darkgreyTheme))
                    ],
                  ),
                  isUploadingFile
                      ? Row(
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  bool? check = await viewModel
                                      .setFile(widget.learningStyle);
                                  if (check != null) {
                                    if (check) {
                                      setState(() {});
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const AlertDialog(
                                                title: Text('Warning'),
                                                content: Text(
                                                    'Invalid file extension for learning style'),
                                              ));
                                    }
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                        widget.lessonType == 'main'
                                            ? ThemeColor.darkgreyTheme
                                            : widget.color[0])),
                                child: const Text('Choose file',
                                    style: TextStyle(
                                        color: ThemeColor.offwhiteTheme))),
                            Text(viewModel.getText())
                          ],
                        )
                      : TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'url here'),
                          controller: viewModel.linkController,
                        ),
                  const SizedBox(height: 20),
                  if (widget.lessonType == 'main') ...[
                    const Text(
                      'CONCEPTS',
                      style: TextStyle(
                          color: ThemeColor.darkgreyTheme, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Container(
                        padding: const EdgeInsets.all(20),
                        width: parentWidth,
                        height: 250,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: ThemeColor.offwhiteTheme)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                            child: Wrap(spacing: 30, children: [
                          ...List.generate(widget.concepts.length, (index) {
                            return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: widget.color[index],
                                  borderRadius: BorderRadius.circular(20)
                                  ),
                                child: Text(
                                  widget.concepts[index],
                                  style: const TextStyle(
                                      color: ThemeColor.offwhiteTheme),
                                ));
                          }),
                        ])))
                  ],
                ],
              ),
            ));
      }),
    );
  }
}
