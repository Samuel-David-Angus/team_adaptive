import 'package:flutter/material.dart';

class AtomicInputMaterialViewModel {
  final titleController = TextEditingController();
  final linkController = TextEditingController();
  List<String> concepts = [];
  String learningStyle = '';
  String type = '';

  bool validate() {
    return titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty &&
        concepts.isNotEmpty &&
        learningStyle.isNotEmpty &&
        type.isNotEmpty;
  }
}
