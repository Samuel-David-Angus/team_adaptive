import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../Components/TemplateView.dart';
import '../Components/TopRightOptions.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);
    return TemplateView(
      highlighted: SELECTED.HOME,
      topRight: authServices != null ? userInfo(context) : authOptions(context, ''),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 800,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/about/hero-about.png'),
                    fit: BoxFit.fitWidth),
              ),
            ),
            const SizedBox(height: 100.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 100.0),
                const Column(
                  children: [
                    Text(
                      'What is',
                      style: TextStyle(
                        color: ThemeColor.darkgreyTheme,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'AdaptiveEdu?',
                      style: TextStyle(
                        color: ThemeColor.darkgreyTheme,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ]
                ),
                const SizedBox(width: 200.0),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 1.5, // Adjust the width as needed
                  ),
                  child: const Text(
                    'AdaptiveEdu is an educational platform assisted by AI to provide adaptive learning '
                    'for students. Learners can view personalized lessons and answer exercises which the '
                    'system assesses for strengths, weaknesses, and skill level, responds with appropriate '
                    'feedback, and presents adjusted lessons for clarification. Teachers can access dynamic '
                    'tools that adjust content based on individual needs and learning preferences. Continuous '
                    'progress tracking and interactive resources guarantee successful execution.',
                    softWrap: true,
                    style: TextStyle(
                      color: ThemeColor.darkgreyTheme,
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 100.0),
            const Text(
              'Developers',
              style: TextStyle(
                color: ThemeColor.darkgreyTheme,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 100.0, vertical: 100.0),
              child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 250.0,
                  alignment: WrapAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 250.0,
                          width: 250.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ThemeColor.darkgreyTheme, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: const Image(image: AssetImage('assets/about/jun.png')),
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          'Samuel David C. Angus',
                          style: TextStyle(
                            color: ThemeColor.darkgreyTheme,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    ),
                    Column(
                      children: [
                        Container(
                          height: 250.0,
                          width: 250.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ThemeColor.darkgreyTheme, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: const Image(image: AssetImage('assets/about/jun.png')),
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          'Jedidiah T. Ramos',
                          style: TextStyle(
                            color: ThemeColor.darkgreyTheme,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    ),
                    Column(
                      children: [
                        Container(
                          height: 250.0,
                          width: 250.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ThemeColor.darkgreyTheme, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: const Image(image: AssetImage('assets/about/jun.png')),
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          'Jun Jeremy F. Tabañag',
                          style: TextStyle(
                            color: ThemeColor.darkgreyTheme,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
