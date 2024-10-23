import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/DataHandler.dart';
import 'package:team_adaptive/Components/TopNavView.dart';
import 'package:team_adaptive/Components/TopNavViewModel.dart';
import 'package:team_adaptive/LandingNavPages/CourseOverviewPage.dart';
import 'package:team_adaptive/LandingNavPages/LessonList.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module1_User_Management/View_Models/LoginViewModel.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module2_Courses/View_Models/StudentCourseViewModel.dart';
import 'package:team_adaptive/Module2_Courses/View_Models/TeacherCourseViewModel.dart';
import 'package:team_adaptive/Module2_Courses/Views/Student/EnrollCourseView.dart';
import 'package:team_adaptive/Module2_Courses/Views/Teacher/TeacherAddCourseView.dart';
import 'package:team_adaptive/Module2_Courses/Views/Teacher/TeacherJoinCourseView.dart';
import 'package:team_adaptive/Module3_Learner/View_Models/StudentLessonViewModel.dart';
import 'package:team_adaptive/Module3_Learner/Views/LearningOutcomeMaterialsView.dart';
import 'package:team_adaptive/Module3_Learner/Views/ViewLessonView.dart';
import 'package:team_adaptive/Module3_Student_Assessment/ViewModels/AssessmentViewModel.dart';
import 'package:team_adaptive/Module3_Student_Assessment/Views/AssessmentView.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Models/FeedbackSummaryModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/ViewModels/FeedbackViewModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Views/FeedbackListView.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Views/FeedbackSummaryView.dart';
import 'package:team_adaptive/Module3_Student_Feedback/Views/LessonMaterialView.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonMaterialModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/View_Models/TeacherLessonViewModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/InitialAddMaterialsView.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherAddLessonView.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Views/TeacherLessonMaterialHomeView.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/View_Models/ConceptMapViewModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Views/ConceptMapView.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Views/SearchExternalLearningOutcomesView.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/View_Models/CreateEditQuestionViewModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/View_Models/TeacherQuestionViewModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Views/TeacherAddQuestionView.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/Views/TeacherViewQuestionView.dart';
import 'package:team_adaptive/Module7_Teacher_Dashboard/Views/LessonDashboardView.dart';
import 'package:team_adaptive/Module7_Teacher_Dashboard/Views/SearchStudentPerformanceView.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import 'LandingNavPages/AboutPage.dart';
import 'LandingNavPages/CoursesPage.dart';
import 'LandingNavPages/HomePage.dart';
import 'Module1_User_Management/View_Models/RegisterViewModel.dart';
import 'Module1_User_Management/Views/LoginView.dart';
import 'Module1_User_Management/Views/RegisterView.dart';
import 'package:go_router/go_router.dart';

final TopNavViewmodel topNavViewmodel = TopNavViewmodel();
final DataHandler dataHandler = DataHandler();

Widget pageHandler<pageType>(AsyncSnapshot snapshot) {
  final Map<Type, Widget Function(AsyncSnapshot)> pageMap = {
    CourseOverviewPage: (snapshot) =>
        CourseOverviewPage(course: snapshot.data! as Course),
    ConceptMapView: (snapshot) =>
        ConceptMapView(course: snapshot.data! as Course),
    FeedbackSummaryView: (snapshot) => FeedbackSummaryView(
        feedbackSummary: snapshot.data! as FeedbackSummaryModel),
    LessonListPage: (snapshot) =>
        LessonListPage(course: snapshot.data! as Course),
    ViewLessonView: (snapshot) {
      LessonAndMaterial res = snapshot.data!;
      return ViewLessonView(
        lesson: res.lesson,
        mainLessonMaterial: res.material,
      );
    },
    AssessmentView: (snapshot) =>
        AssessmentView(lessonModel: snapshot.data! as LessonModel),
    LessonMaterialView: (snapshot) => LessonMaterialView(
        lessonMaterial: snapshot.data! as LessonMaterialModel),
    TeacherLessonMaterialHomeView: (snapshot) =>
        TeacherLessonMaterialHomeView(lesson: snapshot.data! as LessonModel),
    TeacherViewQuestionView: (snapshot) =>
        TeacherViewQuestionView(lesson: snapshot.data! as LessonModel),
    TeacherAddQuestionView: (snapshot) {
      if (snapshot.data! is LessonModel) {
        return TeacherAddQuestionView(
            lessonModel: snapshot.data! as LessonModel);
      }
      QuestionAndLesson res = snapshot.data!;
      return TeacherAddQuestionView(
          lessonModel: res.lesson, question: res.question);
    },
    InitialAddMaterialsView: (snapshot) =>
        InitialAddMaterialsView(lesson: snapshot.data! as LessonModel)
  };

  // Look up the page type in the map
  if (pageMap.containsKey(pageType)) {
    return pageMap[pageType]!(snapshot);
  } else {
    throw UnimplementedError('Unknown pageType: $pageType');
  }
}

FutureBuilder<futureType> routeBuilder<futureType, pageType>(
    Future<futureType> future) {
  return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (snapshot.hasData) {
          return pageHandler<pageType>(snapshot);
        } else {
          return const Center(child: Text("Data Not Found"));
        }
      });
}

final GoRouter _router = GoRouter(
  initialLocation: "/home",
  routes: [
    ShellRoute(
        builder: (context, state, child) => TopNavView(child: child),
        routes: <RouteBase>[
          GoRoute(
              path: '/home',
              builder: (context, state) {
                return const HomePage();
              }),
          GoRoute(
            path: '/about',
            builder: (context, state) {
              return const AboutPage();
            },
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) {
              return const LoginView();
            },
          ),
          GoRoute(
            path: '/register',
            builder: (context, state) {
              return const RegisterView();
            },
          ),
          GoRoute(
            path: '/courses',
            builder: (context, state) {
              return const CoursesPage();
            },
          ),
          GoRoute(
            path: '/courses/add',
            builder: (context, state) => TeacherAddCourseView(),
          ),
          GoRoute(
            path: '/courses/join',
            builder: (context, state) => TeacherJoinCourseView(),
          ),
          GoRoute(
            path: '/courses/enroll',
            builder: (context, state) => EnrollCourseView(),
          ),
          GoRoute(
            path: '/courses/:courseID',
            builder: (context, state) {
              return routeBuilder<Course?, CourseOverviewPage>(
                dataHandler.getCourse(state),
              );
            },
          ),
          GoRoute(
            path: '/courses/:courseID/conceptMap',
            builder: (context, state) => routeBuilder<Course?, ConceptMapView>(
              dataHandler.getCourse(state),
            ),
          ),
          GoRoute(
            path: '/courses/:courseID/lessons',
            builder: (context, state) => routeBuilder<Course?, LessonListPage>(
              dataHandler.getCourse(state),
            ),
          ),
          GoRoute(
            path: '/courses/:courseID/lessons/:lessonID/main/:materialID',
            builder: (context, state) =>
                routeBuilder<LessonAndMaterial?, ViewLessonView>(
              dataHandler.getLessonAndMainMaterial(state),
            ),
          ),
          GoRoute(
            path: '/courses/:courseID/lessons/:lessonID/assessment',
            builder: (context, state) =>
                routeBuilder<LessonModel?, AssessmentView>(
              dataHandler.getLesson(state),
            ),
          ),
          GoRoute(
            path: '/courses/:courseID/lessons/:lessonID/materials',
            builder: (context, state) =>
                routeBuilder<LessonModel?, TeacherLessonMaterialHomeView>(
              dataHandler.getLesson(state),
            ),
          ),
          GoRoute(
            path: '/courses/:courseID/lessons/:lessonID/initialize',
            builder: (context, state) =>
                routeBuilder<LessonModel?, InitialAddMaterialsView>(
              dataHandler.getLesson(state),
            ),
          ),
          GoRoute(
            path: '/courses/:courseID/lessons/:lessonID/questions',
            builder: (context, state) =>
                routeBuilder<LessonModel?, TeacherViewQuestionView>(
              dataHandler.getLesson(state),
            ),
          ),
          GoRoute(
            path: '/courses/:courseID/lessons/:lessonID/questions/add',
            builder: (context, state) =>
                routeBuilder<LessonModel?, TeacherAddQuestionView>(
              dataHandler.getLesson(state),
            ),
          ),
          GoRoute(
            path:
                '/courses/:courseID/lessons/:lessonID/questions/edit/:questionID',
            builder: (context, state) =>
                routeBuilder<QuestionAndLesson?, TeacherAddQuestionView>(
              dataHandler.getQuestionAndLesson(state),
            ),
          ),
          GoRoute(
              path: '/courses/:courseID/lessons/:lessonID/dashboard',
              builder: (context, state) => LessonDashboardView(
                  lessonID: state.pathParameters['lessonID']!,
                  courseID: state.pathParameters['courseID']!)),
          GoRoute(
              path: '/feedbacks',
              builder: (context, state) => const FeedbackListView(),
              routes: <RouteBase>[
                GoRoute(
                    path: ':feedbackID',
                    builder: (context, state) => routeBuilder<
                        FeedbackSummaryModel?,
                        FeedbackSummaryView>(dataHandler.getFeedback(state))),
              ]),
          GoRoute(
              path: '/student-feedbacks/:name',
              builder: (context, state) =>
                  FeedbackListView(userID: state.extra as String?)),
          GoRoute(
              path: '/courses/:courseID/lessons/:lessonID/:type/:materialID',
              builder: (context, state) =>
                  routeBuilder<LessonMaterialModel?, LessonMaterialView>(
                      dataHandler.getLessonMaterial(state))),
          GoRoute(
              path: '/materials/learning-outcome/:LO/:style',
              builder: (context, state) {
                return LearningOutcomeMaterialsView(
                    recommendedStyle: state.pathParameters['style']!,
                    learningOutcome: (state.extra as String? ??
                        Uri.decodeFull(state.pathParameters['LO']!)));
              }),
          GoRoute(
              path: '/test',
              builder: (context, state) =>
                  TeacherAddLessonView(course: state.extra as Course)),
          GoRoute(
            path: '/personal-credential-search',
            builder: (context, state) =>
                const SearchExternalLearningOutcomesView(
              lessonID: null,
            ),
          ),
          GoRoute(
              path: '/student-performance',
              builder: (context, state) => SearchStudentPerformanceView())
        ]),
  ],
);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDBv6AtnL2k6ma3laZVNfkIMRUtb72TlHQ",
            appId: "1:219837929614:web:3857f058d59dd54bf411df",
            messagingSenderId: "219837929614",
            projectId: "adaptiveedu-ccde2"));
  }
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthServices()),
      ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ChangeNotifierProvider(create: (_) => RegisterViewModel()),
      ChangeNotifierProvider(create: (_) => StudentCourseViewModel()),
      ChangeNotifierProvider(create: (_) => TeacherCourseViewModel()),
      ChangeNotifierProvider(create: (_) => ConceptMapViewModel()),
      ChangeNotifierProvider(create: (_) => TeacherLessonViewModel()),
      ChangeNotifierProvider(create: (_) => StudentLessonViewModel()),
      ChangeNotifierProvider(create: (_) => TeacherQuestionViewModel()),
      ChangeNotifierProvider(create: (_) => CreateEditQuestionViewModel()),
      ChangeNotifierProvider(create: (_) => AssessmentViewModel()),
      ChangeNotifierProvider(create: (_) => FeedbackViewModel()),
      ChangeNotifierProvider.value(value: topNavViewmodel)
    ],
    child: const MyApp(),
  ));
  GoRouter.optionURLReflectsImperativeAPIs = true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ThemeColor.blueTheme),
          useMaterial3: true,
          textTheme: GoogleFonts.exoTextTheme(),
        ),
        routerConfig: _router
        //replace routes if there is time since it is apparently not recommended bruh
        // routes: {
        //   '/Home': (context) => const HomePage(),
        //   '/Courses': (context) => const CoursesPage(),
        //   '/About': (context) => const AboutPage(),
        //   '/login': (context) => const LoginView(),
        //   '/register': (context) => const RegisterView(),
        //   '/enroll': (context) => EnrollCourseView(),
        //   '/courseOverview': (context) => CourseOverviewPage(
        //       course: ModalRoute.of(context)?.settings.arguments as Course),
        //   '/addCourse': (context) => TeacherAddCourseView(),
        //   '/joinCourse': (context) => TeacherJoinCourseView(),
        //   '/conceptMap': (context) => ConceptMapView(
        //         course: ModalRoute.of(context)?.settings.arguments as Course,
        //       ),
        // },

        // initialRoute: '/Home', // Specify the initial route
        );
  }
}
