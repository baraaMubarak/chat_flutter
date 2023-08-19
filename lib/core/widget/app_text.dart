import 'package:chat/core/themAndColors/colors.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextAlign? textAlign;
  final String? fontFamily;
  final int? maxLines;
  const AppText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight = FontWeight.w500,
    this.textColor,
    this.textAlign,
    this.fontFamily,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      style: TextStyle(
        color: textColor ?? primaryColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
      ),
    );
  }
}
