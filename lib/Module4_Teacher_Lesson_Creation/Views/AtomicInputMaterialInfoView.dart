import 'package:flutter/material.dart';

class AtomicInputMaterialInfoView extends StatelessWidget {
  const AtomicInputMaterialInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Title'),
            controller: titleController,
          ),
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Upload'),
            controller: linkController,
          ),
          ElevatedButton(
              onPressed: () async {
                selectedConcepts = await showDialog<List<String>>(
                  context: context,
                  builder: (BuildContext context) {
                    return ChangeNotifierProvider.value(
                        value: selectConceptsViewModel,
                        child: TeacherSelectConceptsView(lesson: lesson));
                  },
                );
              },
              child: const Text('Concepts')),
          ElevatedButton(
              onPressed: () async {
                learningStyle = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return ChangeNotifierProvider.value(
                        value: selectLearningStyleViewModel,
                        child: const TeacherSelectLearningStyleView());
                  },
                );
              },
              child: const Text('Learning Styles')),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
