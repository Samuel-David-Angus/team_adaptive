import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/LandingNavPages/CourseOverviewPage.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Module1_User_Management/View_Models/LoginViewModel.dart';
import 'package:team_adaptive/Module2_Courses/Models/CourseModel.dart';
import 'package:team_adaptive/Module2_Courses/View_Models/StudentCourseViewModel.dart';
import 'package:team_adaptive/Module2_Courses/View_Models/TeacherCourseViewModel.dart';
import 'package:team_adaptive/Module2_Courses/Views/Student/EnrollCourseView.dart';
import 'package:team_adaptive/Module2_Courses/Views/Teacher/TeacherAddCourseView.dart';
import 'package:team_adaptive/Module2_Courses/Views/Teacher/TeacherJoinCourseView.dart';
import 'package:team_adaptive/Module3_Learner/View_Models/StudentLessonViewModel.dart';
import 'package:team_adaptive/Module3_Student_Assessment/ViewModels/AssessmentViewModel.dart';
import 'package:team_adaptive/Module3_Student_Feedback/ViewModels/FeedbackViewModel.dart';
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

final GoRouter _router = GoRouter(
  initialLocation: "/home",
  routes: [
    // Home route
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),

    // Courses route
    GoRoute(
      path: '/courses',
      builder: (context, state) => const CoursesPage(),
    ),

    // About route
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutPage(),
    ),

    // Login route
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginView(),
    ),

    // Register route
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterView(),
    ),

    // Enroll route
    GoRoute(
      path: '/enroll',
      builder: (context, state) => EnrollCourseView(),
    ),

    // Course Overview route with course as argument
    GoRoute(
      path: '/courseOverview',
      builder: (context, state) => CourseOverviewPage(
        course: state.extra as Course, // Pass arguments using state.extra
      ),
    ),

    // Add Course route
    GoRoute(
      path: '/addCourse',
      builder: (context, state) => TeacherAddCourseView(),
    ),

    // Join Course route
    GoRoute(
      path: '/joinCourse',
      builder: (context, state) => TeacherJoinCourseView(),
    ),

    // Concept Map route with course as argument
    GoRoute(
      path: '/conceptMap',
      builder: (context, state) => ConceptMapView(
        course: state.extra as Course, // Pass arguments using state.extra
      ),
    ),
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
