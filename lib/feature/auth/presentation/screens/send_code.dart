import 'package:chat/feature/auth/presentation/widget/auth_responsive/auht_responsive.dart';
import 'package:chat/feature/auth/presentation/widget/forms/send_code_form.dart';
import 'package:flutter/material.dart';

class SendCode extends StatelessWidget {
  const SendCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthResponsive(authForm: SendCodeForm()),
    );
  }
}
