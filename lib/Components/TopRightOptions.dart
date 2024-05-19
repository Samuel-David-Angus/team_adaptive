import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_adaptive/Module1_User_Management/Services/AuthServices.dart';


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

List<Widget> userInfo(String? username, String? type, BuildContext context) {
  final authServices = context.read<AuthServices>();
  return [
    Text(username!),
    const SizedBox(width: 10,),
    Text(type!),
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