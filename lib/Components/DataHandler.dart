import 'package:go_router/go_router.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module2_Courses/Services/StudentCourseServices.dart';
import 'package:team_adaptive/Module3_Learner/Services/StudentLessonService.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Services/FeedbackService.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Models/QuestionModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Services/TeacherQuestionService.dart';

class DataHandler {
  Future<Course?>? _course;
  Future<LessonModel?>? _lesson;
  Future<FeedbackModel?>? _feedback;
  Future<LessonMaterialModel?>? _lessonMaterial;
  Future<(QuestionModel, LessonModel)?>? _questionAndLesson;

  Future<Course?> getCourse(GoRouterState state) async {
    if (_course != null) {
      return _course;
    }
    if (state.extra != null && state.extra.runtimeType.toString() != '_JsonMap') {
      return state.extra as Course;
    }
    String? courseID = state.pathParameters['courseID'];
    if (courseID == null) {
      return null;
    }
    _course = StudentCourseServices().getCourseByID(courseID);
    Course? retrievedCourse = await _course;
    _course = null;
    return retrievedCourse;
  }

  Future<FeedbackModel?> getFeedback(GoRouterState state) async {
    if (_feedback != null) {
      return _feedback;
    }
    if (state.extra != null && state.extra.runtimeType.toString() != '_JsonMap') {
      return state.extra as FeedbackModel;
    }
    String? feedbackID = state.pathParameters['feedbackID'];
    if (feedbackID == null) {
      return null;
    }
    _feedback = FeedbackService().getFeedbackByID(feedbackID);
    FeedbackModel? retrievedFeedback = await _feedback;
    _feedback = null;
    return retrievedFeedback;
  }

  Future<LessonModel?> getLesson(GoRouterState state) async {
    if (_lesson != null) {
      return _lesson;
    }
    if (state.extra != null && state.extra.runtimeType.toString() != '_JsonMap') {
      return state.extra as LessonModel;
    }
    String? lessonID = state.pathParameters['lessonID'];
    String? courseID = state.pathParameters['courseID'];
    if (lessonID == null || courseID == null) {
      return null;
    }
    _lesson = StudentLessonService().getLessonByID(courseID, lessonID);
    LessonModel? retrievedLesson = await _lesson;
    _lesson = null;
    return retrievedLesson;
  }

  Future<LessonMaterialModel?> getLessonMaterial(GoRouterState state) async {
    if (_lessonMaterial != null) {
      return _lessonMaterial;
    }
    if (state.extra != null && state.extra.runtimeType.toString() != '_JsonMap') {
      return state.extra as LessonMaterialModel;
    }
    String? courseID = state.pathParameters['courseID'];
    String? lessonID = state.pathParameters['lessonID'];
    String? materialID = state.pathParameters['materialID'];
    String? type = state.pathParameters['type'];
    if (courseID == null ||
        lessonID == null ||
        materialID == null ||
        type == null) {
      return null;
    }
    _lessonMaterial = StudentLessonService().getLessonMaterialByTypeAndID(
        courseID: courseID,
        lessonID: lessonID,
        type: type,
        materialID: materialID);
    LessonMaterialModel? retrievedMaterial = await _lessonMaterial;
    _lessonMaterial = null;
    return retrievedMaterial;
  }

  Future<(QuestionModel, LessonModel)?> getQuestionAndLesson(
      GoRouterState state) async {
    if (_questionAndLesson != null) {
      return _questionAndLesson;
    }
    if (state.extra != null && state.extra.runtimeType.toString() != '_JsonMap') {
      return state.extra as (QuestionModel, LessonModel);
    }
    String? lessonID = state.pathParameters['lessonID'];
    String? questionID = state.pathParameters['questionID'];
    if (lessonID == null || questionID == null) {
      return null;
    }

    Future<(QuestionModel, LessonModel)?> getDataPair() async {
      List<Object?> res = await Future.wait([
        TeacherQuestionService().getQuestionByID(lessonID, questionID),
        getLesson(state),
      ]);
      if (res[0] == null || res[1] == null) {
        return null;
      }
      return (res[0] as QuestionModel, res[1] as LessonModel);
    }

    _questionAndLesson = getDataPair();
    var retrievedPair = await _questionAndLesson;
    _questionAndLesson = null;
    return retrievedPair;
  }
}
