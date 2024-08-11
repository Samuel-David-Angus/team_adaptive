import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module1_User_Management/View_Models/RegisterViewModel.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../Others/enums.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<AssetImage> carouselItems = [
      const AssetImage('assets/hero-register1.png'),
      const AssetImage('assets/hero-register2.png'),
      const AssetImage('assets/hero-register3.png'),
    ];

    final RegisterViewModel viewModel = Provider.of<RegisterViewModel>(context);
    return TemplateView(
      highlighted: SELECTED.NONE,
      topRight: authOptions(context, 'register'),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: CarouselSlider(
              items: carouselItems.map((item) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Transform.scale(
                        scale: 1.3,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: item,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )));
              }).toList(),
              options: CarouselOptions(
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayCurve: Curves.easeInOut,
                autoPlayAnimationDuration: const Duration(milliseconds: 500),
                aspectRatio: 2 / 3,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Register',
                  style: TextStyle(fontSize: 60),
                ),
                const SizedBox(height: 54),
                Consumer<RegisterViewModel>(
                    builder: (context, registerViewModel, child) {
                  return ToggleButtons(
                    isSelected: [
                      registerViewModel.userType == UserType.student,
                      registerViewModel.userType == UserType.teacher,
                    ],
                    onPressed: (int index) {
                      registerViewModel.userType =
                          index == 0 ? UserType.student : UserType.teacher;
                    },
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 100.0, vertical: 8.0),
                        child: Text('Student'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 100.0, vertical: 8.0),
                        child: Text('Teacher'),
                      ),
                    ],
                  );
                }),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 600,
                  child: TextField(
                    onChanged: (value) {
                      viewModel.firstname = value;
                    },
                    decoration: const InputDecoration(
                      fillColor: ThemeColor.offwhiteTheme,
                      filled: true,
                      labelText: 'First name',
                      floatingLabelStyle: TextStyle(
                        color: ThemeColor.blueTheme,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeColor
                                .darkgreyTheme), // Default border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeColor.blueTheme,
                            width: 2), // Border color when focused
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 600,
                  child: TextField(
                    onChanged: (value) {
                      viewModel.firstname = value;
                    },
                    decoration: const InputDecoration(
                      fillColor: ThemeColor.offwhiteTheme,
                      filled: true,
                      labelText: 'Last name',
                      floatingLabelStyle: TextStyle(
                        color: ThemeColor.blueTheme,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeColor
                                .darkgreyTheme), // Default border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeColor.blueTheme,
                            width: 2), // Border color when focused
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 600,
                  child: TextField(
                    onChanged: (value) {
                      viewModel.firstname = value;
                    },
                    decoration: const InputDecoration(
                      fillColor: ThemeColor.offwhiteTheme,
                      filled: true,
                      labelText: 'Username',
                      floatingLabelStyle: TextStyle(
                        color: ThemeColor.blueTheme,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeColor
                                .darkgreyTheme), // Default border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeColor.blueTheme,
                            width: 2), // Border color when focused
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 600,
                  child: TextField(
                    onChanged: (value) {
                      viewModel.firstname = value;
                    },
                    decoration: const InputDecoration(
                      fillColor: ThemeColor.offwhiteTheme,
                      filled: true,
                      labelText: 'Email',
                      floatingLabelStyle: TextStyle(
                        color: ThemeColor.blueTheme,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeColor
                                .darkgreyTheme), // Default border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeColor.blueTheme,
                            width: 2), // Border color when focused
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 600,
                  child: TextField(
                    onChanged: (value) {
                      viewModel.firstname = value;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      fillColor: ThemeColor.offwhiteTheme,
                      filled: true,
                      labelText: 'Password',
                      floatingLabelStyle: TextStyle(
                        color: ThemeColor.blueTheme,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeColor
                                .darkgreyTheme), // Default border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeColor.blueTheme,
                            width: 2), // Border color when focused
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              color: ThemeColor.blueTheme,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        bool validInput = viewModel.validate();
                        if (!validInput) {
                          msgDialogShow(context,
                              'Make sure the fields are all filled correctly. Email must have the correct format. Password must be at least 6 characters long');
                        } else {
                          bool isRegistered = await viewModel.register();
                          if (isRegistered) {
                            Navigator.pushReplacementNamed(context, '/login');
                          } else {
                            msgDialogShow(context,
                                'Registering user failed! Please try again');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 92, vertical: 16),
                        backgroundColor: ThemeColor.darkgreyTheme,
                        foregroundColor: ThemeColor.offwhiteTheme,
                      ),
                      child: const Text('Register',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void msgDialogShow(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Message"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
