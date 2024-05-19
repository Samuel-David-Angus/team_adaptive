import 'package:flutter/material.dart';

import '../Components/TemplateView.dart';
import '../Components/TopRightOptions.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TemplateView(
        highlighted: SELECTED.COURSES,
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
        ));
  }
}