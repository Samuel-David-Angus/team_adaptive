import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module1_User_Management/Models/User.dart';

import '../Others/enums.dart';
import '../View_Models/LoginViewModel.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginViewModel viewModel = Provider.of<LoginViewModel>(context);
    return TemplateView(
        highlighted: SELECTED.NONE,
        topRight: authOptions(context, 'login'),
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
              flex: 6,
              child: Container(
                color: Colors.grey[300],
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.grey[600],
                  ),
                ),
              )
          ),
          const SizedBox(width: 16.0),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text('Login', style: TextStyle(fontSize: 32),),
                const SizedBox(height: 30,),
                Consumer<LoginViewModel>(builder: (context, loginViewModel, child) {
                  return ToggleButtons(
                    isSelected: [
                      loginViewModel.userType == UserType.student,
                      loginViewModel.userType == UserType.teacher,
                    ],
                    onPressed: (int index) {
                      loginViewModel.userType = index == 0 ? UserType.student : UserType.teacher;
                    },
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Student'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Teacher'),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 30,),
                TextField(
                  onChanged: (value){
                    viewModel.email = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  onChanged: (value){
                    viewModel.password = value;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                bool validInput = viewModel.validate();
                if (!validInput) {
                  msgDialogShow(context, 'Make sure the fields are all filled correctly. Email must have the correct format. Password must not be blank');
                } else {
                  bool isLoggedIn = await viewModel.login();
                  if (isLoggedIn) {
                    Navigator.pushReplacementNamed(context, '/Home');
                  } else {
                    msgDialogShow(context, 'Login Failed! Pls try again');
                  }
                }

              },
              child: const Text('Login'),
            ),
              ],
            ),
          ),
        ],
      ),
    )
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