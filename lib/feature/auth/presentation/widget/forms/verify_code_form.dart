import 'package:chat/core/extensions/context_extension.dart';
import 'package:chat/core/extensions/num_extension.dart';
import 'package:chat/core/themAndColors/colors.dart';
import 'package:chat/core/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/widget/loading_dialog.dart';
import '../../bloc/auth/auth_bloc.dart';

class VerifyCodeForm extends StatelessWidget {
  VerifyCodeForm({super.key, this.isResetPasswordSteps = false});

  final _key = GlobalKey<FormState>();
  bool loading = false;
  final TextEditingController pinController = TextEditingController();
  final bool isResetPasswordSteps;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoadingAuthState) {
          if (!loading) {
            LoadingDialog.show(context);
            loading = true;
          }
        } else if (state is ErrorAuthState) {
          if (loading) {
            LoadingDialog.hide(context);
            loading = false;
          }
          context.snackBar(message: state.message, isError: true);
        } else if (state is SuccessVerifyCodeAuthState) {
          if (loading) {
            LoadingDialog.hide(context);
            loading = false;
          }
          context.snackBar(message: 'Verified Code Successful', isError: false);
          if (isResetPasswordSteps) {
            Navigator.pushNamed(context, '/reset_password');
          } else {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                text: 'Verify Code',
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
              ),
              10.height(),
              AppText(
                text: 'We have sent you a code via your e-mail that you previously entered, please check your e-mail and enter the code sent',
                fontSize: 18.sp,
                fontWeight: FontWeight.w100,
                textAlign: TextAlign.center,
              ),
              50.height(),
              Pinput(
                androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                controller: pinController,
                length: 6,
                keyboardType: TextInputType.number,
                defaultPinTheme: PinTheme(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    textStyle: TextStyle(fontSize: 20.sp)),
              ),
              50.height(),
              SizedBox(
                width: 1.sw,
                height: 45.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      BlocProvider.of<AuthBloc>(context).add(VerifyCodeEvent(code: pinController.text));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  child: const AppText(
                    text: 'Verify Code',
                    textColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
