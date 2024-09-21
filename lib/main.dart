import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/DataHandler.dart';
import 'package:team_adaptive/Components/TopNavView.dart';
import 'package:team_adaptive/Components/TopNavViewModel.dart';
import 'package:team_adaptive/LandingNavPages/CourseOverviewPage.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module1_User_Management/View_Models/LoginViewModel.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module2_Courses/Services/StudentCourseServices.dart';
import 'package:team_adaptive/Module2_Courses/View_Models/StudentCourseViewModel.dart';
import 'package:team_adaptive/Module2_Courses/View_Models/TeacherCourseViewModel.dart';
import 'package:team_adaptive/Module2_Courses/Views/Student/EnrollCourseView.dart';
import 'package:team_adaptive/Module2_Courses/Views/Teacher/TeacherAddCourseView.dart';
import 'package:team_adaptive/Module2_Courses/Views/Teacher/TeacherJoinCourseView.dart';
import 'package:team_adaptive/Module3_Learner/View_Models/StudentLessonViewModel.dart';
import 'package:team_adaptive/Module3_Student_Assessment/ViewModels/AssessmentViewModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/ViewModels/FeedbackViewModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/Models/LessonModel.dart';
import 'package:team_adaptive/Module4_Teacher_Lesson_Creation/View_Models/TeacherLessonViewModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/View_Models/ConceptMapViewModel.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Views/ConceptMapView.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/View_Models/CreateEditQuestionViewModel.dart';
import 'package:team_adaptive/Module6_Teacher_Assessment_Creation/View_Models/TeacherQuestionViewModel.dart';
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
              routes: <RouteBase>[
                // join and enroll might not be necessary, confirm and remove or keep later
                GoRoute(
                  path: 'add',
                  builder: (context, state) => TeacherAddCourseView(),
                ),
                GoRoute(
                  path: 'join',
                  builder: (context, state) => TeacherJoinCourseView(),
                ),
                GoRoute(
                  path: 'enroll',
                  builder: (context, state) => EnrollCourseView(),
                ),
                GoRoute(
                    path: ':courseID',
                    builder: (context, state) {
                      return routeBuilder<Course?, CourseOverviewPage>(
                          dataHandler.getCourse(state));
                    },
                    routes: <RouteBase>[
                      GoRoute(
                          path: 'conceptMap',
                          redirect: (context, state) {
                            if (AuthServices().userInfo!.type! == 'teacher') {
                              return null;
                            }
                            return '/courses';
                          },
                          builder: (context, state) =>
                              routeBuilder<Course?, ConceptMapView>(
                                  dataHandler.getCourse(state))),
                    ]),
              ]),
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
