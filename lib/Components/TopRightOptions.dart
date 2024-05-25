import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';

import '../Module1_User_Management/Models/User.dart';


List<Widget> authOptions(context, String highlighted) {
  return [
    ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/register');
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
        Navigator.pushNamed(context, '/login');
      },
      style: ButtonStyle(
        backgroundColor: highlighted == 'login' ? const WidgetStatePropertyAll<Color>(Colors.black): null,
        foregroundColor: highlighted == 'login' ? const WidgetStatePropertyAll<Color>(Colors.white): null,
      ),
      child: const Text('Login'),
    ),
  ];
}

List<Widget> userInfo(User user, BuildContext context) {
  final authServices = context.read<AuthServices>();
  return [
    Text(user.username!),
    const SizedBox(width: 10,),
    Text(user.type!),
    const SizedBox(width: 10,),
    ElevatedButton(
      onPressed: () async {
        await authServices.signOut();
        Navigator.pushNamed(context, '/login');
      },
      child: const Text('Register'),
    ),
  ];
}