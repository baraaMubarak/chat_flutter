import 'package:chat/feature/auth/presentation/widget/auth_image.dart';
import 'package:flutter/material.dart';

class DesktopAndTablet extends StatelessWidget {
  final int formFlex;
  final int imageFlex;
  final Widget formFields;

  const DesktopAndTablet({
    super.key,
    this.formFlex = 1,
    this.imageFlex = 1,
    required this.formFields,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: formFlex,
          child: formFields,
        ),
        Expanded(
          flex: imageFlex,
          child: const AuhImage(),
        ),
      ],
    );
  }
}
