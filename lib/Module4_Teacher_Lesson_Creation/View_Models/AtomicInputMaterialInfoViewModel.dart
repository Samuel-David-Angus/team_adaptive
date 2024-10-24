import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AtomicInputMaterialViewModel {
  final titleController = TextEditingController();
  final linkController = TextEditingController();
  Uint8List? fileBytes;
  String? fileName;
  List<String> concepts = [];
  String learningStyle = '';
  String type = '';

  bool validate() {
    return titleController.text.isNotEmpty &&
        (fileBytes != null || linkController.text.isNotEmpty) &&
        concepts.isNotEmpty &&
        learningStyle.isNotEmpty &&
        type.isNotEmpty;
  }

  bool _checkFileType(PlatformFile file, String learningStyle) {
    String extension = file.name.split('.').last.toLowerCase();
    final textExtensions = ['pdf'];
    final visualExtensions = ['mp4', 'mov', 'avi', 'm4v', 'wmv'];
    final audioExtensions = ['mp3', 'wav', 'aac', 'ogg', 'flac'];

    if (learningStyle == "Text") {
      return textExtensions.contains(extension);
    } else if (learningStyle == "Visual") {
      return visualExtensions.contains(extension);
    } else if (learningStyle == "Audio") {
      return audioExtensions.contains(extension);
    }
    return false;
  }

  Future<bool> setFile(String learningStyle) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      if (!_checkFileType(file, learningStyle)) {
        return false;
      }
      fileBytes = file.bytes;
      fileName = file.name;
      return true;
    }
    return false;
  }

  String getText() {
    if (fileBytes == null && fileName == null) {
      return "No file selected";
    }
    return fileName!;
  }
}
