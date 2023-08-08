import 'package:chat/core/themAndColors/colors.dart';
import 'package:chat/core/widget/app_text.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController? textEditingController;
  final String? Function(String? v)? validator;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final bool readOnly;

  const AppTextField({
    super.key,
    required this.label,
    this.textEditingController,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: textEditingController,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        label: AppText(text: label),
        border: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      ),
    );
  }
}
