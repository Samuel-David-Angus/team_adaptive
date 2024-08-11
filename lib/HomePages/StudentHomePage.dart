import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module2_Courses/View_Models/StudentCourseViewModel.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final TextEditingController textController = TextEditingController();
  bool isCodeIncorrect = false;

  void invalidCode() {
    setState(() {
      isCodeIncorrect = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    StudentCourseViewModel viewModel = Provider.of<StudentCourseViewModel>(context);

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
              padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 200.0),
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
                    'Dive into tailored courses designed to create your personalized learning path. '
                    'Enroll now \nby entering the given course code to start your journey and '
                    'unlock a beneficial learning experience.',
                    style: TextStyle(
                      color: ThemeColor.lightgreyTheme,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  Row(children: [
                    SizedBox(
                      width: 500.0,
                      child: TextField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: ThemeColor.offwhiteTheme,
                          hintText: 'Course Code',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ThemeColor.darkgreyTheme), // Default border color
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ThemeColor.darkgreyTheme,
                              width: 2), // Border color when focused
                          ),
                        ),
                        controller: textController,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    ElevatedButton(
                      onPressed: () async {
                        bool enrolled = await viewModel.enroll(textController.text);
                        if (enrolled) {
                          Navigator.pushNamed(context, '/Courses');
                        } else {
                          invalidCode();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                        backgroundColor: ThemeColor.darkgreyTheme,
                      ),
                      child: const Text(
                        'Enroll',
                        style: TextStyle(
                          fontSize: 18,
                          color: ThemeColor.offwhiteTheme,
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  if (isCodeIncorrect)
                    const Text(
                      'Incorrect course code',
                      style: TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 80.0),
                  Row(
                    children: [
                      const Text(
                        'Explore Courses',
                        style: TextStyle(
                          fontSize: 26,
                          color: ThemeColor.offwhiteTheme,
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/Courses');
                          },
                          child: Transform.scale(
                            scale: 13.0,
                            child: const Image(
                              image: AssetImage('assets/icons/arrow-right.png'),
                            ),
                          ),
                        ),
                      ),
                    ],
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