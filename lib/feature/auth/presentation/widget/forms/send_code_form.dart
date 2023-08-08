import 'package:chat/core/extensions/context_extension.dart';
import 'package:chat/core/extensions/num_extension.dart';
import 'package:chat/core/themAndColors/colors.dart';
import 'package:chat/core/widget/app_text.dart';
import 'package:chat/core/widget/app_text_field.dart';
import 'package:chat/core/widget/loading_dialog.dart';
import 'package:chat/feature/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/feature/auth/presentation/screens/verify_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SendCodeForm extends StatelessWidget {
  SendCodeForm({super.key});

  final TextEditingController emailController = TextEditingController();
  bool loading = false;
  final _key = GlobalKey<FormState>();

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
        } else if (state is SuccessSendCodeAuthState) {
          if (loading) {
            LoadingDialog.hide(context);
            loading = false;
          }
          context.snackBar(message: 'Send Code Successfully', isError: false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VerifyCode(
                isResetPasswordSteps: true,
              ),
            ),
          );
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
                text: 'Enter Your Email',
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
              ),
              10.height(),
              AppText(
                text: 'Enter Your Email To Send Code to it',
                fontSize: 18.sp,
                fontWeight: FontWeight.w100,
                textAlign: TextAlign.center,
              ),
              50.height(),
              AppTextField(
                label: 'Email',
                textEditingController: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please Enter Your Email';
                  }
                  return null;
                },
              ),
              30.height(),
              SizedBox(
                width: 1.sw,
                height: 45.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      BlocProvider.of<AuthBloc>(context).add(SendCodeEvent(
                        email: emailController.text,
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  child: const AppText(
                    text: 'Send Code',
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
