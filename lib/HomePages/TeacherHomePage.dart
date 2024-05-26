import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TemplateView.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module1_User_Management/Models/User.dart';

import '../Module1_User_Management/Services/AuthServices.dart';

class TeacherHomePage extends StatelessWidget {


  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);
    return TemplateView(
        highlighted: SELECTED.HOME,
        topRight: userInfo(context),
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
        ));
  }
}
