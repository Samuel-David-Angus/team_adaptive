import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Models/User.dart';
import 'package:team_adaptive/Module5_Teacher_Concept_Map/Views/SearchExternalLearningOutcomesView.dart';
import 'package:team_adaptive/Module7_Teacher_Dashboard/ViewModels/SearchStudentPerformanceViewModel.dart';

class SearchStudentPerformanceView extends StatelessWidget {
  final SearchStudentPerformanceViewModel viewModel =
      SearchStudentPerformanceViewModel();
  final TextEditingController textEditingController = TextEditingController();
  SearchStudentPerformanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: FutureBuilder<List<User>>(
          future: viewModel.getStudents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Display the error
            } else if (snapshot.hasData) {
              List<User> students = snapshot.data!;
              return Consumer<SearchStudentPerformanceViewModel>(
                  builder: (context, viewModel, child) {
                return Column(
                  children: [
                    DropdownMenu(
                      controller: textEditingController,
                      enableFilter: true,
                      dropdownMenuEntries: students.map((User student) {
                        String fullname =
                            "${student.lastname!}, ${student.firstname!}";
                        return DropdownMenuEntry(
                            value: student.id!, label: fullname);
                      }).toList(),
                      onSelected: (value) {
                        viewModel.setSelectedStudent(value!);
                      },
                    ),
                    if (viewModel.studentID != null) ...[
                      ElevatedButton(
                          onPressed: () {
                            User student = students.firstWhere((student) =>
                                student.id! == viewModel.studentID);
                            String name = Uri.encodeFull(
                                "${student.lastname!} ${student.firstname!}");
                            GoRouter.of(context).go('/student-feedbacks/$name',
                                extra: viewModel.studentID);
                          },
                          child: const Text('Check feedbacks')),
                      Expanded(
                        child: SearchExternalLearningOutcomesView(
                          lessonID: null,
                          studentID: viewModel.studentID!,
                        ),
                      )
                    ]
                  ],
                );
              });
            } else {
              return const Text('No data available');
            }
          }),
    );
  }
}
