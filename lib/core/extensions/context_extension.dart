import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localization.dart';
// import 'package:turaifi/core/constants/app_text_style.dart';

extension MyContext on BuildContext {
  // AppLocalizations localizations() {
  //   return AppLocalizations.of(this)!;
  // }

  void snackBar({required String message, bool? isError}) {
    Future.delayed(
      Duration.zero,
      () => ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(
            message,
            // style: AppTextStyle.caption,
          ),
          backgroundColor: isError == null ? (Colors.grey) : (isError ? Colors.redAccent : Colors.green),
        ),
      ),
    );
  }
}
