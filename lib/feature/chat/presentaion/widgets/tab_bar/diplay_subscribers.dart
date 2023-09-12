import 'package:chat/core/extensions/num_extension.dart';
import 'package:chat/core/themAndColors/colors.dart';
import 'package:chat/core/widget/app_text.dart';
import 'package:chat/feature/auth/data/data_source/auth_local_data_source.dart';
import 'package:chat/feature/auth/domain/entities/User.dart';
import 'package:chat/feature/chat/data/datat_source/chat_local_data_source.dart';
import 'package:chat/feature/chat/domain/entities/message.dart';
import 'package:chat/feature/chat/presentaion/bloc/chat/chat_bloc.dart';
import 'package:chat/feature/chat/presentaion/bloc/selected_user/selected_user_bloc.dart';
import 'package:chat/feature/chat/presentaion/widgets/user_container.dart';
import 'package:chat/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DisplaySubscribers extends StatefulWidget {
  final void Function()? searchOnNewUserOnPress;

  DisplaySubscribers({
    super.key,
    this.searchOnNewUserOnPress,
  });

  @override
  State<DisplaySubscribers> createState() => _DisplaySubscribersState();
}

class _DisplaySubscribersState extends State<DisplaySubscribers> {
  final List<User> subscribers = di.sl<AuthLocalDataSource>().getUser()!.subscribers!;
  late List<User?> searchSubscribers = [];
  TextEditingController searchController = TextEditingController();
  final ChatLocalDataSource _chatLocalDataSource = ChatLocalDataSourceImp();
  Message? lastMessage;
  bool isMyMessage = false;
  bool isSelected = false;

  @override
  void initState() {
    searchSubscribers.addAll(subscribers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          15.height(),
          SizedBox(
            height: 50.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'Chats',
                  fontWeight: FontWeight.w900,
                  textAlign: TextAlign.start,
                  fontSize: 25.sp,
                ),
                Container(
                  height: 25.h,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: widget.searchOnNewUserOnPress,
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ),
                )
              ],
            ),
          ),
          15.height(),
          Container(
            height: 40.h,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: TextField(
              maxLines: 1,
              onChanged: (v) {
                searchSubscribers.clear();
                setState(() {
                  if (v != '' || v.isNotEmpty) {
                    for (int i = 0; i < subscribers.length; i++) {
                      if (subscribers[i].name!.toLowerCase().contains(v.toLowerCase())) {
                        searchSubscribers.add(subscribers[i]);
                      }
                    }
                  } else if (v.isEmpty) {
                    searchSubscribers.addAll(subscribers);
                  }
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search, color: primaryColor),
                contentPadding: const EdgeInsets.all(0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                  gapPadding: 10,
                ),
              ),
            ),
          ),
          15.height(),
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                searchSubscribers = sort(users: searchSubscribers);
                return ListView.builder(
                  itemCount: searchSubscribers.length,
                  itemBuilder: (context, index) {
                    final messages = _chatLocalDataSource.getMessagesByUserId(userId: searchSubscribers[index]!.sid!);
                    if (messages.isNotEmpty) {
                      lastMessage = messages.last;
                      isMyMessage = messages.last.senderId == di.sl<AuthLocalDataSource>().getUser()!.sid! || messages.last.senderId == null;
                    } else {
                      lastMessage = null;
                    }
                    return UserContainer(
                      user: searchSubscribers[index]!,
                      lastMessage: lastMessage,
                      isMyMessage: isMyMessage,
                      onTap: () {
                        BlocProvider.of<ChatBloc>(context).add(GetPreviousMessageEvent(
                          userId: searchSubscribers[index]!.sid!,
                        ));
                        BlocProvider.of<SelectedUserBloc>(context).add(ChangeSelectedUserEvent(
                          user: searchSubscribers[index]!,
                        ));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<User> sort({required List<User?> users}) {
    List<User> sortedUsers = List.from(users.where((user) => user != null).cast<User>());

    sortedUsers.sort((userA, userB) {
      final String userIdA = userA.sid ?? '';
      final String userIdB = userB.sid ?? '';

      final List<Message> messagesA = _chatLocalDataSource.getMessagesByUserId(userId: userIdA);
      final List<Message> messagesB = _chatLocalDataSource.getMessagesByUserId(userId: userIdB);

      String lastMessageCreatedAtA = '';
      if (messagesA.isNotEmpty) {
        if (messagesA.isNotEmpty && messagesA.last.createdAt != null) {
          lastMessageCreatedAtA = messagesA.last.createdAt!.toLocal().toString();
        }
      } else if (messagesA.isEmpty) {
        lastMessageCreatedAtA = '';
      }
      String lastMessageCreatedAtB = '';
      if (messagesB.isNotEmpty) {
        if (messagesB.last.createdAt != null) {
          lastMessageCreatedAtB = messagesB.isNotEmpty ? messagesB.last.createdAt!.toLocal().toString() : '';
        }
      } else if (messagesB.isEmpty) {
        lastMessageCreatedAtB = '';
      }

      return lastMessageCreatedAtB.compareTo(lastMessageCreatedAtA);
    });

    return sortedUsers;
  }
}
