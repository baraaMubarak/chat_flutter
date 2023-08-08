import 'package:chat/core/responsive/responsive.dart';
import 'package:chat/feature/auth/presentation/widget/auth_responsive/desktop_and_taplet.dart';
import 'package:flutter/material.dart';

class AuthResponsive extends StatelessWidget {
  final Widget authForm;
  const AuthResponsive({
    super.key,
    required this.authForm,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: authForm,
      tablet: DesktopAndTablet(
        formFlex: 10,
        imageFlex: 9,
        formFields: authForm,
      ),
      desktop: DesktopAndTablet(
        formFields: authForm,
      ),
    );
  }
}
