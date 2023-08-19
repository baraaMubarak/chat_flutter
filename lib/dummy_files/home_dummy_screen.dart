import 'package:chat/core/widget/app_text.dart';
import 'package:chat/feature/chat/domain/entities/message.dart';
import 'package:chat/feature/chat/presentaion/bloc/chat/chat_bloc.dart';
import 'package:chat/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeDummyScreen extends StatelessWidget {
  const HomeDummyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ChatBloc>()
        ..add(ChatSendMessageEvent(
          message: Message(message: 'bloc', receiverId: '64dbb904d7dca31fb404be78'),
        )),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: AppText(
                text: 'Home',
                fontSize: 30.sp,
              ),
            ),
          );
        },
      ),
    );
  }
}
