import 'package:chat/feature/auth/presentation/widget/auth_responsive/auht_responsive.dart';
import 'package:chat/feature/auth/presentation/widget/forms/login_form.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthResponsive(authForm: LoginForm()),
    );
  }
}
