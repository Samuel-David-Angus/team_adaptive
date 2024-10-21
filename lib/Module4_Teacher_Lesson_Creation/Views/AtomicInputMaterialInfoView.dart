import 'package:flutter/material.dart';

import '../Models/LessonModel.dart';
import '../View_Models/AtomicInputMaterialInfoViewModel.dart';

class AtomicInputMaterialInfoView extends StatelessWidget {
  final viewModel = AtomicInputMaterialViewModel();
  final LessonModel lesson;
  final void Function(AtomicInputMaterialViewModel) connector;
  final String lessonType;
  final List<String> concepts;
  final String learningStyle;
  AtomicInputMaterialInfoView(
      {super.key,
      required this.lesson,
      required this.connector,
      required this.lessonType,
      required this.concepts,
      required this.learningStyle}) {
    viewModel.type = lessonType;
    viewModel.concepts = concepts;
    viewModel.learningStyle = learningStyle;
    connector(viewModel);
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
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Upload'),
            controller: viewModel.linkController,
          ),
          const Text('Concepts: '),
          ...List.generate(concepts.length, (index) {
            return Text(concepts[index]);
          }),
          Text('Learning Style: $learningStyle'),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
