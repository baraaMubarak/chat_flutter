import 'package:chat/feature/auth/data/data_source/auth_local_data_source.dart';
import 'package:chat/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LunchScreen extends StatefulWidget {
  const LunchScreen({super.key});

  @override
  State<LunchScreen> createState() => _LunchScreenState();
}

class _LunchScreenState extends State<LunchScreen> {
  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        String? token = di.sl<AuthLocalDataSource>().getToken();
        if (token != null) {
          context.replaceNamed('home');
        } else {
          context.replaceNamed('login');
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
