import 'package:chat/core/api/socket_controller.dart';
import 'package:chat/core/responsive/responsive.dart';
import 'package:chat/core/widget/app_text.dart';
import 'package:chat/feature/chat/presentaion/bloc/search/search_bloc.dart';
import 'package:chat/feature/chat/presentaion/bloc/selected_user/selected_user_bloc.dart';
import 'package:chat/feature/chat/presentaion/widgets/chat_widget.dart';
import 'package:chat/feature/chat/presentaion/widgets/tab_bar/tab_bar_for_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SocketController.getInstance(context: context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SelectedUserBloc(),
        ),
        BlocProvider(
          create: (context) => SearchBloc(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const AppText(
            text: 'Chat',
            fontWeight: FontWeight.w800,
            fontSize: 25,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Responsive(
            mobile: BlocBuilder<SelectedUserBloc, SelectedUserState>(
              builder: (context, state) {
                if (state is SelectedUserInitialState) {
                  return const TabBarForHome();
                } else {
                  return Chat();
                }
              },
            ),
            desktop: Row(
              children: [
                const Expanded(child: TabBarForHome()),
                Expanded(
                  flex: 2,
                  child: Chat(),
                ),
              ],
            ),
            tablet: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: TabBarForHome(),
                ),
                Expanded(
                  flex: 3,
                  child: Chat(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
