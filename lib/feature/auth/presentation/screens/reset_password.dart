import 'package:chat/feature/auth/presentation/widget/auth_responsive/auht_responsive.dart';
import 'package:chat/feature/auth/presentation/widget/forms/reset_password_form.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthResponsive(authForm: ResetPasswordForm()),
    );
  }
}
