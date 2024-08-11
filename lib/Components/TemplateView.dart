import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 6,
                  blurRadius: 6,
                  offset: const Offset(0, 4), // Positive offset for bottom shadow
                ),
              ],
            ),
            child: AppBar(
              title: Wrap(spacing: 100, children: topLeft),
              actions: topRight,
            ),
          ),
        ),
        body: child,
      ),
    );
  }
}
