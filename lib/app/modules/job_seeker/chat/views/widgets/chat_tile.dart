import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/modules/job_seeker/chat/model/chat_model.dart';
import 'package:hire_me/app/modules/job_seeker/chat/views/widgets/avatar.dart';
import 'package:hire_me/app/modules/job_seeker/chat/views/widgets/chat_info.dart';
import 'package:hire_me/app/modules/job_seeker/chat/views/widgets/chat_meta.dart';
import 'package:hire_me/app/modules/job_seeker/chat_details/views/chat_details_view.dart';
import 'package:hire_me/core/utils/app_color.dart';

class ChatTile extends StatelessWidget {
  final ChatModel chat;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  ChatTile({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(
              () => ChatDetailsView(
                chatName: chat.otherName(currentUserId),
                avatarUrl: chat.avatarUrl,
                seekerId: chat.seekerId,
                companyId: chat.companyId,
              ),
              arguments: {'chatId': chat.id},
              transition: Transition.rightToLeft,
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Avatar(
                  name: chat.otherName(currentUserId),
                  avatarUrl: chat.avatarUrl,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ChatInfo(
                    name: chat.otherName(currentUserId), // ✅
                    lastMessage: chat.lastMessage,
                    lastMessageAuthor: chat.lastMessageAuthor,

                    currentUserId: currentUserId,
                  ),
                ),
                ChatMeta(
                  time: chat.lastMessageTime,
                  unreadCount: chat.unreadFor(
                    FirebaseAuth.instance.currentUser!.uid,
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1, color: AppColor.divider),
      ],
    );
  }
}
