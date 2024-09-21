import 'package:go_router/go_router.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module2_Courses/Services/StudentCourseServices.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';

class DataHandler {
  late Future<Course?> _course;
  bool _isCourseLoading = false;

  late Future<LessonModel> _lesson;
  bool _isLessonLoading = false;

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
}
