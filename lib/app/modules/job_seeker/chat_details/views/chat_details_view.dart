import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hire_me/app/modules/job_seeker/chat_details/views/widgets/chat_details_appbar.dart';
import 'package:hire_me/app/modules/job_seeker/chat_details/views/widgets/message_input.dart';
import 'package:hire_me/app/modules/job_seeker/chat_details/views/widgets/message_list.dart';
import 'package:hire_me/core/utils/app_color.dart';

import '../controllers/chat_details_controller.dart';

class ChatDetailsView extends StatelessWidget {
  final String chatName;
  final String avatarUrl;

  const ChatDetailsView({
    super.key,
    required this.chatName,
    this.avatarUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      ChatDetailsController(chatName: chatName),
      tag: chatName,
    );

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: ChatDetailsAppbar(name: chatName, avatarUrl: avatarUrl),
      body: Column(
        children: [
          Expanded(child: MessagesList(controller: controller)),
          MessageInput(controller: controller),
        ],
      ),
    );
  }
}
