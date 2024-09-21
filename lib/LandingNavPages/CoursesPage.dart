import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module2_Courses/Views/Student/StudentCoursesView.dart';
import 'package:team_adaptive/Module2_Courses/Views/Teacher/TeacherCoursesView.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../Module1_User_Management/Services/AuthServices.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);
    String? type = authServices.userInfo?.type;

    if (authServices.currentUser == null || type == null) {
      return SingleChildScrollView(
        child: Stack(
          children: [
            // Background Image
            Container(
              height: MediaQuery.of(context).size.height - kToolbarHeight,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/hero-courses.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 900.0, // Set the desired width here
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 100.0, vertical: 200.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enroll Now in Courses',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 60),
                      const Text(
                        'Unlock access to a wide range of adaptive learning experiences '
                        'designed to suit your individual needs. To enroll in a course, '
                        'please sign up or log in to your account. Once you\'re signed in, '
                        'you\'ll need the unique course code provided by your instructor to '
                        'join. Start your learning journey with us today!',
                        style: TextStyle(
                          color: ThemeColor.darkgreyTheme,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          GoRouter.of(context).push('/register');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          backgroundColor: ThemeColor.darkgreyTheme,
                        ),
                        child: const Text(
                          'Sign up now',
                          style: TextStyle(
                            fontSize: 18,
                            color: ThemeColor.lightgreyTheme,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return type == 'teacher'
        ? const TeacherCoursesView()
        : const StudentCoursesView();
  }
}
