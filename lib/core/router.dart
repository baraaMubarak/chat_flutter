import 'package:chat/feature/auth/presentation/screens/login.dart';
import 'package:chat/feature/auth/presentation/screens/lunch.dart';
import 'package:chat/feature/auth/presentation/screens/register.dart';
import 'package:chat/feature/auth/presentation/screens/reset_password.dart';
import 'package:chat/feature/auth/presentation/screens/send_code.dart';
import 'package:chat/feature/auth/presentation/screens/verify_code.dart';
import 'package:chat/feature/chat/presentaion/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'lunch', // Optional, add name to your routes. Allows you navigate by name instead of path
      path: '/',
      builder: (context, state) => const LunchScreen(),
    ),
    GoRoute(
      name: 'login', // Optional, add name to your routes. Allows you navigate by name instead of path
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: 'verify_code',
      path: '/verify_code',
      builder: (context, state) {
        bool isResetPasswordSteps = bool.parse(state.pathParameters['isResetPasswordSteps'] ?? 'false');
        return VerifyCode(isResetPasswordSteps: isResetPasswordSteps);
      },
    ),
    GoRoute(
      name: 'register',
      path: '/register',
      builder: (context, state) => const Register(),
    ),
    GoRoute(
      name: 'home',
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      name: 'reset_password',
      path: '/reset_password',
      builder: (context, state) => const ResetPassword(),
    ),
    GoRoute(
      name: 'send_code',
      path: '/send_code',
      builder: (context, state) => const SendCode(),
    ),
  ],
);
