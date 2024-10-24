import 'package:flutter/material.dart';

import '../Models/LessonModel.dart';
import '../View_Models/AtomicInputMaterialInfoViewModel.dart';

class AtomicInputMaterialInfoView extends StatefulWidget {
  final LessonModel lesson;
  final void Function(AtomicInputMaterialViewModel) connector;
  final String lessonType;
  final List<String> concepts;
  final String learningStyle;
  const AtomicInputMaterialInfoView(
      {super.key,
      required this.lesson,
      required this.connector,
      required this.lessonType,
      required this.concepts,
      required this.learningStyle});
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Title'),
            controller: viewModel.titleController,
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
                      ? Colors.green
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
              Text(isUploadingFile ? "Uploading file" : "Uploading link")
            ],
          ),
          isUploadingFile
              ? Row(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          bool check =
                              await viewModel.setFile(widget.learningStyle);
                          if (check) {
                            setState(() {});
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                      title: Text('Warning'),
                                      content: Text(
                                          'Invalid file extension for learning style'),
                                    ));
                          }
                        },
                        child: const Text('Choose file')),
                    Text(viewModel.getText())
                  ],
                )
              : TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'url here'),
                  controller: viewModel.linkController,
                ),
          const Text('Concepts: '),
          ...List.generate(widget.concepts.length, (index) {
            return Text(widget.concepts[index]);
          }),
          Text('Learning Style: ${widget.learningStyle}'),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
