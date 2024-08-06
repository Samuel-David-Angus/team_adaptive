import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Models/User.dart';
import 'package:team_adaptive/Module1_User_Management/Views/LoginView.dart';

import '../Module1_User_Management/Services/AuthServices.dart';

enum SELECTED { HOME, COURSES, ABOUT, NONE }

class TemplateView extends StatelessWidget {
  Widget child;
  List<Widget> topRight;
  SELECTED highlighted;

  List<String> navBtns = ['Home', 'Courses', 'About'];

  TemplateView({
    super.key,
    required this.child,
    required this.highlighted,
    required this.topRight,
  });

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);

    List<Widget> topLeft = [
      const Text('AdaptiveEdu'),
    ];
    topLeft.addAll(List.generate(navBtns.length, (index) {
      Text text = Text(navBtns[index]);
      if (index == highlighted.index && index != SELECTED.NONE.index) {
        text = Text(
          navBtns[index],
          style: const TextStyle(decoration: TextDecoration.underline),
        );
      }
      return TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/${navBtns[index]}');
          },
          child: text);
    }));

    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
            title: Wrap(spacing: 100, children: topLeft), actions: topRight),
        body: child,
      ),
    );
  }
}
