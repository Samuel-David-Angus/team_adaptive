import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/HomePages/StudentHomePage.dart';
import 'package:team_adaptive/HomePages/TeacherHomePage.dart';

import '../Module1_User_Management/Services/AuthServices.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);
    String? type = authServices.userInfo?.type;
    if (authServices.currentUser == null || type == null) {
      return TemplateView(
        highlighted: SELECTED.HOME,
        topRight: authOptions(context, ''),
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
              const Expanded(
                flex: 4,
                child: Placeholder(),
              ),
            ],
          ),
        ),
      );
    }
    return type == 'teacher' ? const TeacherHomePage() : const StudentHomePage();
  }
}
