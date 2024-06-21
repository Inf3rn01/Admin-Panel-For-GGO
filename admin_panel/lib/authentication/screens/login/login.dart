import 'package:admin_panel/authentication/screens/login/widgets/login_form.dart';
import 'package:admin_panel/authentication/screens/login/widgets/login_header.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 200, horizontal: 100),
          child: Column(
            children: [
              
              /// Logo, Title & Sub-Title
              GLoginHeader(),

              /// Form
              GLoginForm(),

            ],
          ),
        ),
      ),
    );
  }
}
