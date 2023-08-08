import 'package:chat/core/shared_pref/shared_pref.dart';
import 'package:chat/feature/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chat/feature/auth/presentation/screens/login.dart';
import 'package:chat/feature/auth/presentation/screens/register.dart';
import 'package:chat/feature/auth/presentation/screens/reset_password.dart';
import 'package:chat/feature/auth/presentation/screens/send_code.dart';
import 'package:chat/feature/auth/presentation/screens/verify_code.dart';
import 'package:chat/home_dummy_screen.dart';
import 'package:chat/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefController().initSharedPref();
  await di.init();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => BlocProvider(
        create: (context) => di.sl<AuthBloc>(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const Register(),
            '/verify_code': (context) => const VerifyCode(),
            '/home': (context) => const HomeDummyScreen(),
            '/reset_password': (context) => const ResetPassword(),
            '/send_code': (context) => const SendCode(),
          },
        ),
      ),
    );
  }
}
