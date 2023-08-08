import 'package:chat/core/widget/app_text.dart';
import 'package:chat/feature/auth/presentation/widget/widget_shap_marker/RPS_custom_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuhImage extends StatelessWidget {
  const AuhImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1600004853937-857d1070d505?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8aGludGVyZ3J1bmR8ZW58MHx8MHx8fDA%3D&w=1000&q=80',
            ),
            fit: BoxFit.fill),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 50.h,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  text: 'Welcome To Chat',
                  textColor: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 30.sp,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            child: CustomPaint(
              size: Size(200.w, (200.w * 0.625).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
              painter: RPSCustomPainter(),
            ),
          ),
        ],
      ),
    );
  }
}
