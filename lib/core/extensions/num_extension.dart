import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension MyNum on num {
  SizedBox height() {
    return SizedBox(
      height: h,
    );
  }

  SizedBox width() {
    return SizedBox(
      width: h,
    );
  }
}
