import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TopNavViewModel.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';
import 'package:team_adaptive/Theme/ThemeColor.dart';

List<Widget> authOptions(context, topNavViewModel) {
  String highlighted = "";
  final RouteMatch lastMatch =
      GoRouter.of(context).routerDelegate.currentConfiguration.last;
  final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
      ? lastMatch.matches
      : GoRouter.of(context).routerDelegate.currentConfiguration;
  final String location = matchList.uri.toString();

  if (location == "/register") {
    highlighted = "register";
  } else if (location == "/login") {
    highlighted = "login";
  }

  return [
    ElevatedButton(
      onPressed: () {
        GoRouter.of(context).go('/register');
        topNavViewModel.setSelected(SELECTED.NONE);
      },
      style: ButtonStyle(
        backgroundColor: highlighted == 'register'
            ? const WidgetStatePropertyAll<Color>(Colors.black)
            : null,
        foregroundColor: highlighted == 'register'
            ? const WidgetStatePropertyAll<Color>(Colors.white)
            : null,
      ),
      child: const Text('Register'),
    ),
    const SizedBox(
      width: 10,
    ),
    ElevatedButton(
      onPressed: () {
        GoRouter.of(context).go('/login');
        topNavViewModel.setSelected(SELECTED.NONE);
      },
      style: ButtonStyle(
        backgroundColor: highlighted == 'login'
            ? const WidgetStatePropertyAll<Color>(Colors.black)
            : null,
        foregroundColor: highlighted == 'login'
            ? const WidgetStatePropertyAll<Color>(Colors.white)
            : null,
      ),
      child: const Text('Login'),
    ),
  ];
}

List<Widget> userInfo(BuildContext context, TopNavViewmodel topNavViewModel) {
  final authServices = context.read<AuthServices>();
  final user = authServices.userInfo;
  return [
    Text(
      user!.username!,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    const SizedBox(
      width: 10,
    ),
    Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: user.type == 'student'
          ? ThemeColor.studentTheme
          : ThemeColor.teacherTheme,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        user.type! == 'student' ? 'Student' : 'Teacher',
        style: const TextStyle(
          color: Colors.white,),
        ),
    ),
    const SizedBox(
      width: 10,
    ),
    ElevatedButton(
      onPressed: () async {
        await authServices.signOut();
        topNavViewModel.setSelected(SELECTED.NONE);
        context.go('/login');
      },
      child: const Text('Sign out'),
    ),
  ];
}
