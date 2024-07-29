import 'package:flutter/cupertino.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Models/QuestionModel.dart';

import '../../Module5_Teacher_Concept_Map/Models/ConceptMapModel.dart';

class CreateEditQuestionViewModel extends ChangeNotifier {
  TextEditingController questionController = TextEditingController();
  TextEditingController choiceController = TextEditingController();
  List<TextEditingController> choiceList = [];
  int? indexOfCorrectAnswer;
  String? concept;

  void initializeCreate() {
    questionController.clear();
    choiceController.clear();
    choiceList = [];
    indexOfCorrectAnswer = null;
    concept = null;
  }
  void initializeEdit(QuestionModel question) {
    questionController.text = question.question;
    choiceController.clear();
    choiceList = question.wrongChoices.map(
        (wrongChoice) => TextEditingController(text: wrongChoice)
    ).toList();
    indexOfCorrectAnswer = 0;
    choiceList.insert(indexOfCorrectAnswer!, TextEditingController(text: question.correctAnswer));
    concept = question.questionConcept;
  }

  QuestionModel createQuestionModel(String userID, ConceptMapModel conceptMapModel) {
    late String correctAnswer;
    List<String> wrongAnswers = [];
    for (int i = 0; i < choiceList.length; i++) {
      if (i == indexOfCorrectAnswer) {
        correctAnswer = choiceList[i].text;
      } else {
        wrongAnswers.add(choiceList[i].text);
      }
    }

    return QuestionModel.newlyCreated(authorID: userID, question: questionController.text, correctAnswer: correctAnswer, wrongChoices: wrongAnswers, questionConcept: concept!, conceptMapModel: conceptMapModel);
  }

  bool validateBeforeSubmitting() {
    return questionController.text.isNotEmpty && choiceList.length > 1 && indexOfCorrectAnswer != null && concept != null;
  }

  bool validateChoice() {
    return choiceController.text.isNotEmpty;
  }

  void setConcept(String? concept) {
    this.concept = concept;
    notifyListeners();
  }

  void addChoice() {
    choiceList.add(choiceController);
    choiceController = TextEditingController();
    notifyListeners();
  }

  void deleteChoice(int index) {
    choiceList.removeAt(index);
    if (indexOfCorrectAnswer != null) {
      if (indexOfCorrectAnswer! > index) {
        indexOfCorrectAnswer = indexOfCorrectAnswer! - 1;
      } else if (indexOfCorrectAnswer! == index) {
        indexOfCorrectAnswer = null;
      }
    }
    notifyListeners();
  }

  void setCorrectAnswer(int index) {
    indexOfCorrectAnswer = index;
    notifyListeners();
  }




}