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

typedef QuestionAndLesson = ({QuestionModel question, LessonModel lesson});
typedef LessonAndMaterial = ({
  LessonModel lesson,
  LessonMaterialModel material
});

class DataHandler {
  Future<Course?> getCourse(GoRouterState state) async {
    if (state.extra != null &&
        state.extra.runtimeType.toString() != '_JsonMap') {
      return state.extra as Course;
    }
    String? courseID = state.pathParameters['courseID'];
    if (courseID == null) {
      return null;
    }
    Course? retrievedCourse =
        await StudentCourseServices().getCourseByID(courseID);
    return retrievedCourse;
  }

  Future<FeedbackModel?> getFeedback(GoRouterState state) async {
    if (state.extra != null &&
        state.extra.runtimeType.toString() != '_JsonMap') {
      return state.extra as FeedbackModel;
    }
    String? feedbackID = state.pathParameters['feedbackID'];
    if (feedbackID == null) {
      return null;
    }
    FeedbackModel? retrievedFeedback =
        await FeedbackService().getFeedbackByID(feedbackID);
    return retrievedFeedback;
  }

  Future<LessonModel?> getLesson(GoRouterState state) async {
    if (state.extra != null &&
        state.extra.runtimeType.toString() != '_JsonMap') {
      return state.extra as LessonModel;
    }
    String? lessonID = state.pathParameters['lessonID'];
    String? courseID = state.pathParameters['courseID'];
    if (lessonID == null || courseID == null) {
      return null;
    }
    LessonModel? retrievedLesson =
        await StudentLessonService().getLessonByID(courseID, lessonID);
    return retrievedLesson;
  }

  Future<LessonMaterialModel?> getLessonMaterial(GoRouterState state,
      {String? type}) async {
    if (state.extra != null &&
        state.extra.runtimeType.toString() != '_JsonMap') {
      return state.extra as LessonMaterialModel;
    }
    String? courseID = state.pathParameters['courseID'];
    String? lessonID = state.pathParameters['lessonID'];
    String? materialID = state.pathParameters['materialID'] ??
        state.uri.queryParameters['material'];
    type ??= state.pathParameters['type'];
    if (courseID == null ||
        lessonID == null ||
        materialID == null ||
        type == null) {
      return null;
    }
    LessonMaterialModel? retrievedMaterial = await StudentLessonService()
        .getLessonMaterialByTypeAndID(
            courseID: courseID,
            lessonID: lessonID,
            type: type,
            materialID: materialID);
    return retrievedMaterial;
  }

  Future<QuestionAndLesson?> getQuestionAndLesson(GoRouterState state) async {
    if (state.extra != null &&
        state.extra.runtimeType.toString() != '_JsonMap') {
      return state.extra as QuestionAndLesson;
    }
    String? lessonID = state.pathParameters['lessonID'];
    String? questionID = state.pathParameters['questionID'];
    if (lessonID == null || questionID == null) {
      return null;
    }

    Future<QuestionAndLesson?> getDataPair() async {
      List<Object?> res = await Future.wait([
        TeacherQuestionService().getQuestionByID(lessonID, questionID),
        getLesson(state),
      ]);
      if (res[0] == null || res[1] == null) {
        return null;
      }
      return (question: res[0] as QuestionModel, lesson: res[1] as LessonModel);
    }

    var retrievedPair = await getDataPair();
    return retrievedPair;
  }

  Future<LessonAndMaterial> getLessonAndMainMaterial(
      GoRouterState state) async {
    if (state.extra != null &&
        state.extra.runtimeType.toString() != '_JsonMap') {
      return state.extra as ({
        LessonModel lesson,
        LessonMaterialModel material
      });
    }
    List<Object?> res = await Future.wait(
        [getLesson(state), getLessonMaterial(state, type: "main")]);
    return (
      lesson: res[0] as LessonModel,
      material: res[1] as LessonMaterialModel
    );
  }
}
