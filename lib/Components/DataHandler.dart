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
  late Future<Course?> _course;
  bool _isCourseLoading = false;

  late Future<LessonModel> _lesson;
  bool _isLessonLoading = false;

  late Future<FeedbackModel?> _feedback;
  bool _isFeedbackLoading = false;

  late Future<LessonMaterialModel?> _lessonMaterial;
  bool _isMaterialLoading = false;

  late Future<(QuestionModel, LessonModel)?> _questionAndLesson;
  bool _isQuestionAndLessonLoading = false;

  Future<Course?> getCourse(GoRouterState state) async {
    if (_isCourseLoading) {
      return _course;
    }
    _isCourseLoading = true;
    if (state.extra != null) {
      _isCourseLoading = false;
      return state.extra as Course;
    }
    String? courseID = state.pathParameters['courseID'];
    if (courseID == null) {
      _isCourseLoading = false;
      return null;
    }
    Course? retrievedCourse =
        await StudentCourseServices().getCourseByID(courseID);
    _isCourseLoading = false;
    return retrievedCourse;
  }

  Future<FeedbackModel?> getFeedback(GoRouterState state) async {
    if (_isFeedbackLoading) {
      return _feedback;
    }
    _isFeedbackLoading = true;
    if (state.extra != null) {
      _isFeedbackLoading = false;
      return state.extra as FeedbackModel;
    }
    String? feedbackID = state.pathParameters['feedbackID'];
    if (feedbackID == null) {
      _isFeedbackLoading = false;
      return null;
    }
    FeedbackModel? retrievedFeedback =
        await FeedbackService().getFeedbackByID(feedbackID);
    _isFeedbackLoading = false;
    return retrievedFeedback;
  }

  Future<LessonModel?> getLesson(GoRouterState state) async {
    if (_isLessonLoading) {
      return _lesson;
    }
    _isLessonLoading = true;
    if (state.extra != null) {
      _isLessonLoading = false;
      return state.extra as LessonModel;
    }
    String? lessonID = state.pathParameters['lessonID'];
    String? courseID = state.pathParameters['courseID'];
    if (lessonID == null || courseID == null) {
      _isLessonLoading = false;
      return null;
    }
    LessonModel? retrievedLesson =
        await StudentLessonService().getLessonByID(courseID, lessonID);
    _isLessonLoading = false;
    return retrievedLesson;
  }

  Future<LessonMaterialModel?> getLessonMaterial(GoRouterState state) async {
    if (_isMaterialLoading) {
      return _lessonMaterial;
    }
    _isMaterialLoading = true;
    if (state.extra != null) {
      _isMaterialLoading = false;
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
      _isMaterialLoading = false;
      return null;
    }
    LessonMaterialModel? retrievedMaterial = await StudentLessonService()
        .getLessonMaterialByTypeAndID(
            courseID: courseID,
            lessonID: lessonID,
            type: type,
            materialID: materialID);
    _isMaterialLoading = false;
    return retrievedMaterial;
  }

  Future<(QuestionModel, LessonModel)?> getQuestionAndLesson(
      GoRouterState state) async {
    if (_isQuestionAndLessonLoading) {
      return _questionAndLesson;
    }
    _isQuestionAndLessonLoading = true;
    if (state.extra != null) {
      _isQuestionAndLessonLoading = false;
      return state.extra as (QuestionModel, LessonModel);
    }
    String? lessonID = state.pathParameters['lessonID'];
    String? questionID = state.pathParameters['questionID'];
    if (lessonID == null || questionID == null) {
      _isQuestionAndLessonLoading = false;
      return null;
    }
    List<Object?> res = await Future.wait([
      TeacherQuestionService().getQuestionByID(lessonID, questionID),
      getLesson(state),
    ]);
    if (res[0] == null || res[1] == null) {
      _isQuestionAndLessonLoading = false;
      return null;
    }
    _isQuestionAndLessonLoading = false;
    return (res[0] as QuestionModel, res[1] as LessonModel);
  }
}
