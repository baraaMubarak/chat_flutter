import 'package:chat/core/extensions/context_extension.dart';
import 'package:chat/core/extensions/num_extension.dart';
import 'package:chat/core/responsive/responsive.dart';
import 'package:chat/core/themAndColors/colors.dart';
import 'package:chat/core/widget/app_text.dart';
import 'package:chat/core/widget/app_text_field.dart';
import 'package:chat/core/widget/loading_dialog.dart';
import 'package:chat/feature/auth/domain/entities/User.dart';
import 'package:chat/feature/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/feature/auth/presentation/bloc/gender/gender_bloc.dart';
import 'package:chat/feature/auth/presentation/widget/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm({super.key});

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDayController = TextEditingController();
  bool loading = false;
  final _key = GlobalKey<FormState>();
  Gender gender = Gender.male;

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
        } else if (state is SuccessRegisterAuthState) {
          if (loading) {
            LoadingDialog.hide(context);
            loading = false;
          }
          context.snackBar(message: 'The registration has been completed successfully, but you must verify your email', isError: false);
          Navigator.pushNamed(context, '/verify_code');
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
                text: 'Welcome',
                fontWeight: FontWeight.w700,
                fontSize: 24.sp,
              ),
              10.height(),
              AppText(
                text: 'Welcome To Chat',
                fontSize: 18.sp,
                fontWeight: FontWeight.w100,
                textAlign: TextAlign.center,
              ),
              50.height(),
              AppTextField(
                label: 'User Name',
                textEditingController: userNameController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please Enter Your Name';
                  }
                  return null;
                },
              ),
              30.height(),
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
              30.height(),
              StatefulBuilder(
                builder: (context, setState) => AppTextField(
                  textEditingController: birthDayController,
                  label: 'Date Of Pirth',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: SizedBox(
                            height: 250,
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                                SizedBox(
                                  height: 200,
                                  child: AppDatePicker(
                                    upperLimit: DateTime.now(),
                                    dateChangedCallback: (date) {
                                      setState(() => birthDayController.text = date.toString().split(' ')[0]);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please Enter Your Date Of Birth';
                    }
                    return null;
                  },
                ),
              ),
              10.height(),
              if (Responsive.isMobile(context) || Responsive.isTablet(context)) 20.height(),
              if (Responsive.isMobile(context) || Responsive.isTablet(context))
                const Row(
                  children: [
                    Text(
                      'Select Gender:',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              BlocProvider(
                create: (context) => GenderBloc()
                  ..add(ChangeGenderEvent(
                    newGender: Gender.male,
                  )),
                child: BlocBuilder<GenderBloc, GenderState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (Responsive.isDesktop(context) || Responsive.isMobileLarge(context))
                          const Text(
                            'Select Gender:',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.start,
                          ),
                        if (state is ChangedGenderState)
                          Expanded(
                            child: RadioListTile(
                              title: const AppText(text: 'Male'),
                              value: Gender.male,
                              groupValue: state.gender,
                              onChanged: (value) {
                                gender = Gender.male;
                                BlocProvider.of<GenderBloc>(context).add(
                                  ChangeGenderEvent(
                                    newGender: Gender.male,
                                  ),
                                );
                              },
                            ),
                          ),
                        if (state is ChangedGenderState)
                          Expanded(
                            child: RadioListTile(
                              title: const AppText(text: 'Female'),
                              value: Gender.female,
                              groupValue: state.gender,
                              onChanged: (value) {
                                gender = Gender.female;
                                BlocProvider.of<GenderBloc>(context).add(
                                  ChangeGenderEvent(
                                    newGender: Gender.female,
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              30.height(),
              SizedBox(
                width: 1.sw,
                height: 45.h,
                child: ElevatedButton(
                  onPressed: () {
                    Logger().v(gender);
                    if (_key.currentState!.validate()) {
                      BlocProvider.of<AuthBloc>(context).add(
                        RegisterEvent(
                          user: User(
                            name: userNameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            gender: gender,
                            dateOfBirth: birthDayController.text,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  child: const AppText(
                    text: 'Register',
                    textColor: Colors.white,
                  ),
                ),
              ),
              20.height(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
                child: const AppText(
                  text: 'You Have Account? Login',
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
