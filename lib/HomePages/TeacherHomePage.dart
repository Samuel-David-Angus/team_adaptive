import 'package:flutter/material.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

class TeacherHomePage extends StatelessWidget {


  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateView(
        highlighted: SELECTED.HOME,
        topRight: userInfo(context),
        child: SingleChildScrollView(
            child: Stack(
            children: [
              // Background Image
              Container(
                height: MediaQuery.of(context).size.height - kToolbarHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/hero-home-authenticated.png'),
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
                    const Wrap(
                      spacing: -30.0,
                      direction: Axis.vertical,
                      children: [
                        Text(
                          'Welcome to',
                          style: TextStyle(
                            color: ThemeColor.offwhiteTheme,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'AdaptiveEdu',
                          style: TextStyle(
                            color: ThemeColor.offwhiteTheme,
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    
                    const SizedBox(height: 60),
                    const Text(
                      'Empower your students with personalized learning experiences. '
                      'Click below to get started on creating \nengaging courses and lessons '
                      'tailored to their unique needs.',
                      style: TextStyle(
                        color: ThemeColor.lightgreyTheme,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/Courses');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        backgroundColor: ThemeColor.offwhiteTheme,
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 18,
                          color: ThemeColor.darkgreyTheme,
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
}
