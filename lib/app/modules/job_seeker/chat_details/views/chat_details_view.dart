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
  final String seekerId;
  final String companyId;

  const ChatDetailsView({
    super.key,
    required this.chatName,
    required this.seekerId,
    required this.companyId,
    this.avatarUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    ///todo
    final controller = Get.put(
      ChatDetailsController(
        chatName: chatName,
        chatAvatarUrl: avatarUrl,
        chatId: Get.arguments?['chatId'] ?? '', // ✅ null check
        seekerId: seekerId,
        companyId: companyId,
      ),
      tag: chatName,
    );

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: ChatDetailsAppbar(name: chatName, avatarUrl: avatarUrl),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(), // ✅
                );
              }
              return MessagesList(controller: controller);
            }),
          ),
          MessageInput(controller: controller),
        ],
      ),
    );
  }
}
