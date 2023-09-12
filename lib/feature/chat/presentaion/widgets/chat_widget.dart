import 'package:chat/core/extensions/num_extension.dart';
import 'package:chat/core/responsive/responsive.dart';
import 'package:chat/core/themAndColors/colors.dart';
import 'package:chat/core/widget/app_text.dart';
import 'package:chat/core/widget/loading_dialog.dart';
import 'package:chat/feature/auth/data/data_source/auth_local_data_source.dart';
import 'package:chat/feature/auth/data/model/user.dart';
import 'package:chat/feature/chat/data/datat_source/chat_local_data_source.dart';
import 'package:chat/feature/chat/domain/entities/message.dart';
import 'package:chat/feature/chat/presentaion/bloc/chat/chat_bloc.dart';
import 'package:chat/feature/chat/presentaion/bloc/selected_user/selected_user_bloc.dart';
import 'package:chat/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;

class Chat extends StatelessWidget {
  Chat({super.key});

  final TextEditingController _sendMessageController = TextEditingController();
  final ChatLocalDataSource _chatLocalDataSource = ChatLocalDataSourceImp();
  final FocusNode focusNode = FocusNode();
  bool isRTL = false;
  bool isFirstMessage = false;

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
                      IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.videocam_sharp)),
                      PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(child: Text('block')),
                            const PopupMenuItem(child: Text('block')),
                            const PopupMenuItem(child: Text('block')),
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
                      if (messages.isEmpty) {
                        isFirstMessage = true;
                      }
                      bool nextMessageIsMyMessage = false;
                      return Visibility(
                        visible: chatState is ChatLoadingState && messages.isEmpty,
                        replacement: ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, realIndex) {
                            int index = messages.length - 1 - realIndex;
                            // Logger().t(MessageModel.fromMessage(messages[index]).toJson());
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
                        ),
                        child: const LoadingDialog(),
                      );
                    },
                  ),
                ),
                10.height(),
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
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return TextField(
                            controller: _sendMessageController,
                            focusNode: focusNode,
                            autofocus: true,
                            keyboardType: TextInputType.multiline,
                            maxLines: 1,
                            onChanged: (v) {
                              setState(() => isRTL = intl.Bidi.detectRtlDirectionality(v));
                            },
                            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                            onSubmitted: (value) => onSend(context, state, UserModel(state.user)),
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
                                        onSend(context, state, UserModel(state.user));
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
                          );
                        },
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

  onSend(BuildContext context, state, UserModel userModel) {
    if (_sendMessageController.text.isNotEmpty) {
      BlocProvider.of<ChatBloc>(context).add(ChatSendMessageEvent(
        message: Message(
          receiverId: state.user.sid,
          message: _sendMessageController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now().toString(),
        ),
      ));
      if (isFirstMessage) {
        di.sl<AuthLocalDataSource>().addSubscriber(userModel);
      }
      // Logger().i('${(!isFirstMessage).toString()} : ${di.sl<AuthLocalDataSource>().getUser()!.subscribers!}');
    }
    _sendMessageController.clear();
    focusNode.requestFocus();
  }
}
