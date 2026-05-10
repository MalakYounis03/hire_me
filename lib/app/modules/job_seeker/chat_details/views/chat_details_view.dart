import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'widgets/chat_details_appbar.dart';
import 'widgets/message_input.dart';
import 'widgets/message_list.dart';
import '../../../../../core/utils/app_color.dart';

import '../controllers/chat_details_controller.dart';

class ChatDetailsView extends StatelessWidget {
  final String chatName;
  final String avatarUrl;
  final String seekerId;
  final String companyId;

  const ChatDetailsView({
    super.key,
    this.chatName = '',
    this.seekerId = '',
    this.companyId = '',
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
