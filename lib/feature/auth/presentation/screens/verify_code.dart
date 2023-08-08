import 'package:chat/feature/auth/presentation/widget/forms/verify_code_form.dart';
import 'package:flutter/material.dart';

import '../widget/auth_responsive/auht_responsive.dart';

class VerifyCode extends StatelessWidget {
  const VerifyCode({super.key, this.isResetPasswordSteps = false});

  final bool isResetPasswordSteps;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthResponsive(
          authForm: VerifyCodeForm(
        isResetPasswordSteps: isResetPasswordSteps,
      )),
    );
  }
}
