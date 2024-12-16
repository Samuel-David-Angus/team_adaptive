import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                const EdgeInsets.symmetric(horizontal: 100.0, vertical: 100.0),
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
                    GoRouter.of(context).go('/courses');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    backgroundColor: ThemeColor.darkgreyTheme,
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      color: ThemeColor.offwhiteTheme,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  decoration: BoxDecoration(
                    color: ThemeColor.offwhiteTheme,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 6,
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: ThemeColor.lightgreyTheme,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Start tracking your student's performance",
                          style: TextStyle(
                            color: ThemeColor.darkgreyTheme,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 8),
                      TextButton(
                        onPressed: () async {
                          GoRouter.of(context).go('/student-performance');
                        },
                        style: ButtonStyle(overlayColor:
                            WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.hovered)) {
                              return Colors.transparent;
                            }
                            return Colors.transparent;
                          },
                        ), textStyle:
                            WidgetStateProperty.resolveWith<TextStyle>(
                                (Set<WidgetState> states) {
                          if (states.contains(WidgetState.hovered)) {
                            return const TextStyle(
                                decoration: TextDecoration.underline);
                          }
                          return const TextStyle();
                        })),
                        child: const Text(
                          'Check Now →',
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
        ],
      ),
    );
  }
}
