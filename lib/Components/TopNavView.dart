import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Components/TopNavViewModel.dart';
import 'package:team_adaptive/Components/TopRightOptions.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';

class TopNavView extends StatelessWidget {
  final Widget child;
  const TopNavView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);
    final viewModel = Provider.of<TopNavViewmodel>(context);

    List<Widget> topLeft = [
      const Text('AdaptiveEdu'),
    ];
    topLeft.addAll(List.generate(viewModel.navBtns.length, (index) {
      Text text = Text(viewModel.navBtns[index]);
      if (index == viewModel.highlighted.index &&
          index != SELECTED.NONE.index) {
        text = Text(
          viewModel.navBtns[index],
          style: const TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold),
        );
      }
      return TextButton(
          onPressed: () {
            viewModel.setSelected(SELECTED.values[index]);
            GoRouter.of(context).go("/${viewModel.navBtns[index]}");
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
                  offset:
                      const Offset(0, 4), // Positive offset for bottom shadow
                ),
              ],
            ),
            child: AppBar(
              title: Wrap(spacing: 100, children: topLeft),
              actions: authServices.userInfo == null
                  ? authOptions(context)
                  : userInfo(context),
            ),
          ),
        ),
        body: child,
      ),
    );
  }
}
