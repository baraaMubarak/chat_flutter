import 'package:chat/core/extensions/num_extension.dart';
import 'package:chat/core/responsive/responsive.dart';
import 'package:chat/core/themAndColors/colors.dart';
import 'package:chat/core/widget/app_text.dart';
import 'package:chat/feature/auth/data/data_source/auth_local_data_source.dart';
import 'package:chat/feature/chat/data/datat_source/chat_local_data_source.dart';
import 'package:chat/feature/chat/data/model/message_model.dart';
import 'package:chat/feature/chat/domain/entities/message.dart';
import 'package:chat/feature/chat/presentaion/bloc/chat/chat_bloc.dart';
import 'package:chat/feature/chat/presentaion/bloc/selected_user/selected_user_bloc.dart';
import 'package:chat/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';

class Chat extends StatelessWidget {
  Chat({super.key});

  final TextEditingController _sendMessageController = TextEditingController();
  final ChatLocalDataSource _chatLocalDataSource = ChatLocalDataSourceImp();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: BlocBuilder<SelectedUserBloc, SelectedUserState>(
        builder: (context, state) {
          if (state is SelectedUserChangeState) {
            return Column(
              children: [
                Container(
                  height: 55.h,
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        blurStyle: BlurStyle.outer,
                        offset: Offset(5, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // if (Responsive.isMobile(context))
                      IconButton(
                        onPressed: () {
                          BlocProvider.of<SelectedUserBloc>(context).add(ResetSelectedUserEvent());
                        },
                        icon: Icon(
                          Responsive.isMobile(context) || Responsive.isMobileLarge(context) ? Icons.arrow_back_ios : Icons.close,
                        ),
                      ),
                      const CircleAvatar(),
                      15.width(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              text: state.user.name!,
                              fontWeight: FontWeight.w800,
                            ),
                            AppText(text: state.user.email!),
                          ],
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Icons.call)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.videocam_sharp)),
                      PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(child: Text('block')),
                            PopupMenuItem(child: Text('block')),
                            PopupMenuItem(child: Text('block')),
                          ];
                        },
                      ),
                    ],
                  ),
                ),
                15.height(),
                Expanded(
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, chatState) {
                      List<Message> messages = _chatLocalDataSource.getMessagesByUserId(userId: state.user.sid!);
                      bool nextMessageIsMyMessage = false;
                      return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          Logger().t(MessageModel.fromMessage(messages[index]).toJson());
                          bool isMyMessage = messages[index].senderId == di.sl<AuthLocalDataSource>().getUser()!.sid! || messages[index].senderId == null;
                          if (index + 1 < messages.length) {
                            nextMessageIsMyMessage = messages[index + 1].senderId == di.sl<AuthLocalDataSource>().getUser()!.sid! || messages[index + 1].senderId == null;
                          } else {
                            nextMessageIsMyMessage = false;
                          }
                          if (isMyMessage) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 5.h),
                                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadiusDirectional.only(
                                      bottomStart: Radius.circular(10.r),
                                      bottomEnd: nextMessageIsMyMessage ? Radius.zero : Radius.circular(10.r),
                                      topStart: Radius.circular(10.r),
                                    ),
                                  ),
                                  child: AppText(
                                    text: messages[index].message!,
                                    textColor: Colors.white,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 5.h),
                                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadiusDirectional.only(
                                      bottomEnd: Radius.circular(10.r),
                                      bottomStart: !nextMessageIsMyMessage ? Radius.zero : Radius.circular(10.r),
                                      topEnd: Radius.circular(10.r),
                                    ),
                                  ),
                                  child: AppText(
                                    text: messages[index].message!,
                                    textColor: Colors.black,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                Container(
                  height: 60.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        blurStyle: BlurStyle.outer,
                        offset: Offset(5, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: TextField(
                        controller: _sendMessageController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 1,
                        onChanged: (v) {},
                        decoration: InputDecoration(
                          hintText: 'Type a message here...',
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          prefixIcon: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.file_present, color: primaryColor),
                            ),
                          ),
                          suffixIcon: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.emoji_emotions_outlined,
                                    color: primaryColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.keyboard_voice_outlined,
                                    color: primaryColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    BlocProvider.of<ChatBloc>(context).add(ChatSendMessageEvent(
                                      message: Message(
                                        receiverId: state.user.sid,
                                        message: _sendMessageController.text,
                                      ),
                                    ));
                                    _sendMessageController.clear();
                                  },
                                  icon: Icon(
                                    Icons.send_outlined,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 30.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            borderSide: BorderSide.none,
                            gapPadding: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: AppText(
                text: 'Welcome Back',
                fontSize: 100.sp,
                fontWeight: FontWeight.w900,
              ),
            );
          }
        },
      ),
    );
  }
}
