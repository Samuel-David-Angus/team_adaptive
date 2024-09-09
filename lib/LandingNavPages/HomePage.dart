import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/HomePages/StudentHomePage.dart';
import 'package:team_adaptive/HomePages/TeacherHomePage.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../Module1_User_Management/Services/AuthServices.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);
    String? type = authServices.userInfo?.type;
    if (authServices.currentUser == null || type == null) {
      return TemplateView(
        highlighted: SELECTED.HOME,
        topRight: authOptions(context, ''),
        child: SingleChildScrollView(
            child: Stack(
            children: [
              // Background Image
              Container(
                height: MediaQuery.of(context).size.height - kToolbarHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/hero-home.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 100.0, vertical: 200.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Experience \nAdaptive Learning',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 60),
                    const Text(
                      'AdaptiveEdu is a platform that empowers teachers to create and deliver '
                      'personalized\nlearning experiences tailored to the needs of each student. ',
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
            ],
          ),
        ),
      );
    }
    return type == 'teacher'
        ? const TeacherHomePage()
        : const StudentHomePage();
  }
}
