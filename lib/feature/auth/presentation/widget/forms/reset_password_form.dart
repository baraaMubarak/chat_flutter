import 'package:chat/core/extensions/context_extension.dart';
import 'package:chat/core/extensions/num_extension.dart';
import 'package:chat/core/themAndColors/colors.dart';
import 'package:chat/core/widget/app_text.dart';
import 'package:chat/core/widget/app_text_field.dart';
import 'package:chat/core/widget/loading_dialog.dart';
import 'package:chat/feature/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/feature/chat/presentaion/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordForm extends StatelessWidget {
  ResetPasswordForm({super.key});

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
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
        } else if (state is SuccessResetPasswordAuthState) {
          if (loading) {
            LoadingDialog.hide(context);
            loading = false;
          }
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false);
          context.snackBar(message: 'Reset password Successfully', isError: false);
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
                text: 'Reset New Password',
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
              ),
              10.height(),
              AppText(
                text: 'Welcome Back, Please Enter Your New Password',
                fontSize: 18.sp,
                fontWeight: FontWeight.w100,
                textAlign: TextAlign.center,
              ),
              50.height(),
              AppTextField(
                label: 'New Password',
                textEditingController: passwordController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please Enter Your New Password';
                  }
                  return null;
                },
              ),
              30.height(),
              AppTextField(
                label: 'Confirm Password',
                textEditingController: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please Confirm Password';
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
                    if (_key.currentState!.validate() && passwordController.text == confirmPasswordController.text) {
                      BlocProvider.of<AuthBloc>(context).add(ResetPasswordEvent(
                        password: passwordController.text,
                      ));
                    } else if (passwordController.text != confirmPasswordController.text) {
                      context.snackBar(message: 'Confirm Password is Not Same With Password');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  child: const AppText(
                    text: 'Reset Password',
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
