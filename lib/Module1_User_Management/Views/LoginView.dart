import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

import '../Others/enums.dart';
import '../View_Models/LoginViewModel.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginViewModel viewModel = Provider.of<LoginViewModel>(context);

    final List<AssetImage> carouselItems = [
      const AssetImage('assets/hero-register1.png'),
      const AssetImage('assets/hero-register2.png'),
      const AssetImage('assets/hero-register3.png'),
    ];

    return Row(
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
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 50),
                ),
                const SizedBox(
                  height: 30,
                ),
                Consumer<LoginViewModel>(
                    builder: (context, loginViewModel, child) {
                  return SizedBox(
                    height: 50,
                    child: ToggleButtons(
                      isSelected: [
                        loginViewModel.userType == UserType.student,
                        loginViewModel.userType == UserType.teacher,
                      ],
                      onPressed: (int index) {
                        loginViewModel.userType =
                            index == 0 ? UserType.student : UserType.teacher;
                      },
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 100),
                          child: Text('Student', textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 100),
                          child: Text('Teacher', textAlign: TextAlign.center),
                        )
                      ],
                    ),
                  );
                }),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 600.0,
                  child: TextField(
                    onChanged: (value) {
                      viewModel.email = value;
                    },
                    decoration: const InputDecoration(
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
                  width: 600.0,
                  child: TextField(
                    onChanged: (value) {
                      viewModel.password = value;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
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
                          'Don\'t have an account? ',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/register');
                          },
                          child: const Text(
                            'Register',
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
                              'Make sure the fields are all filled correctly. Email must have the correct format. Password must not be blank');
                        } else {
                          bool isLoggedIn = await viewModel.login();
                          if (isLoggedIn) {
                            GoRouter.of(context).go('/home');
                          } else {
                            msgDialogShow(
                                context, 'Login Failed! Pls try again');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 20),
                        backgroundColor: ThemeColor.darkgreyTheme,
                        foregroundColor: ThemeColor.offwhiteTheme,
                      ),
                      child:
                          const Text('Login', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
