import 'package:chat/core/extensions/num_extension.dart';
import 'package:chat/core/themAndColors/colors.dart';
import 'package:chat/core/widget/app_text.dart';
import 'package:chat/feature/auth/domain/entities/User.dart';
import 'package:chat/feature/chat/domain/entities/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class UserContainer extends StatelessWidget {
  const UserContainer({
    super.key,
    required this.user,
    this.lastMessage,
    this.isMyMessage = false,
    this.onTap,
    this.isSelected = false,
  });

  final User user;
  final Message? lastMessage;
  final bool isMyMessage;
  final bool isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
        margin: EdgeInsets.symmetric(vertical: 5.h),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 4),
          ],
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            const CircleAvatar(),
            7.width(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(text: user.name!, fontWeight: FontWeight.w800, textColor: isSelected ? Colors.white : null),
                  AppText(text: lastMessage != null ? (isMyMessage ? 'you: ' : '') + lastMessage!.message! : '', maxLines: 1, textColor: isSelected ? Colors.white : null),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  text: lastMessage != null ? formatDateTime(DateTime.parse(lastMessage!.createdAt.toString()).toLocal()) : '',
                  fontSize: 12.sp,
                  textColor: isSelected ? Colors.white : null,
                ),
                if (!isSelected)
                  Container(
                    padding: EdgeInsets.all(5.r),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: AppText(
                      text: '3',
                      textColor: Colors.white,
                      fontSize: 10.sp,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    final isToday = difference.inDays == 0;
    final isYesterday = difference.inDays == 1;

    if (isToday || isYesterday) {
      final formattedTime = DateFormat.jm().format(dateTime); // Apply 12-hour format
      return isToday ? formattedTime : 'Yesterday $formattedTime';
    } else {
      final formattedDateTime = DateFormat('h:mm a, d/M').format(dateTime); // Apply 12-hour format
      return formattedDateTime;
    }
  }
}
