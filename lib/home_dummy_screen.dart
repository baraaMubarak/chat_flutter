import 'package:chat/core/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeDummyScreen extends StatelessWidget {
  const HomeDummyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText(
        text: 'Home',
        fontSize: 30.sp,
      ),
    );
  }
}
