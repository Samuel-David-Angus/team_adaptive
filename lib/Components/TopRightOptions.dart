import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';


List<Widget> authOptions(context, String highlighted) {
  return [
    ElevatedButton(
      onPressed: () {
        GoRouter.of(context).push('/register');
      },
      style: ButtonStyle(
        backgroundColor: highlighted == 'register' ? const WidgetStatePropertyAll<Color>(Colors.black): null,
        foregroundColor: highlighted == 'register' ? const WidgetStatePropertyAll<Color>(Colors.white): null,
      ),
      child: const Text('Register'),
    ),
    const SizedBox(width: 10,),
    ElevatedButton(
      onPressed: () {
        GoRouter.of(context).push('/login');
      },
      style: ButtonStyle(
        backgroundColor: highlighted == 'login' ? const WidgetStatePropertyAll<Color>(Colors.black): null,
        foregroundColor: highlighted == 'login' ? const WidgetStatePropertyAll<Color>(Colors.white): null,
      ),
      child: const Text('Login'),
    ),
  ];
}

List<Widget> userInfo(BuildContext context) {
  final authServices = context.read<AuthServices>();
  final user = authServices.userInfo;
  return [
    Text(user!.username!),
    const SizedBox(width: 10,),
    Text(user!.type!),
    const SizedBox(width: 10,),
    ElevatedButton(
      onPressed: () async {
        await authServices.signOut();
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login', // Replace with your target route name
          (Route<dynamic> route) => false, // This removes all the previous routes
        );
      },
      child: const Text('Sign out'),
    ),
  ];
}
