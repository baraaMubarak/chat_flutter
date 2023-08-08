import 'package:chat/core/extensions/context_extension.dart';
import 'package:chat/core/extensions/num_extension.dart';
import 'package:chat/core/strings/failure.dart';
import 'package:chat/core/themAndColors/colors.dart';
import 'package:chat/core/widget/app_text.dart';
import 'package:chat/core/widget/app_text_field.dart';
import 'package:chat/core/widget/loading_dialog.dart';
import 'package:chat/feature/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
          if (state.message == EMAIL_IS_NOT_VERIFIED) {
            Navigator.pushNamed(context, '/verify_code');
          }
          context.snackBar(message: state.message, isError: true);
        } else if (state is SuccessLoginAuthState) {
          if (loading) {
            LoadingDialog.hide(context);
            loading = false;
          }
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          context.snackBar(message: 'Login Successfully', isError: false);
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
                text: 'Welcome Back',
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
              ),
              10.height(),
              AppText(
                text: 'Welcome Back, Please Enter Your Details',
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
              AppTextField(
                label: 'Password',
                textEditingController: passwordController,
                keyboardType: TextInputType.visiblePassword,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please Enter Your Password';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/send_code');
                    },
                    child: const AppText(
                      text: 'Forgot Password?',
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              30.height(),
              SizedBox(
                width: 1.sw,
                height: 45.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      BlocProvider.of<AuthBloc>(context).add(LoginEvent(
                        email: emailController.text,
                        password: passwordController.text,
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  child: const AppText(
                    text: 'Login',
                    textColor: Colors.white,
                  ),
                ),
              ),
              20.height(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const AppText(
                  text: 'You Don\'t Have Account? Create Account',
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
