import 'package:flutter/material.dart';

import 'SelectConceptsViewModel.dart';
import 'SelectLearningStyleViewModel.dart';

class AtomicInputMaterialViewModel extends ChangeNotifier {
  final titleController = TextEditingController();
  final linkController = TextEditingController();
  final selectConceptsViewModel = SelectConceptsViewModel();
  final selectStyleViewModel = SelectLearningStyleViewModel();
  String type = '';

  bool validate() {
    return titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty &&
        selectConceptsViewModel.selectedItems!.isNotEmpty &&
        selectStyleViewModel.selectedStyle.isNotEmpty;
  }
}
