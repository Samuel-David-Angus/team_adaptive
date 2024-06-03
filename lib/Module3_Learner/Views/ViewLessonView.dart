import 'package:flutter/material.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module3_Learner/Views/Iframe.dart';

class ViewLessonView extends StatelessWidget {
  String src;
  ViewLessonView({super.key, required this.src});

  @override
  Widget build(BuildContext context) {
    return TemplateView(
        highlighted: SELECTED.NONE,
        topRight: userInfo(context),
        child: IframeView(
          source: src,
        ));
  }
}
