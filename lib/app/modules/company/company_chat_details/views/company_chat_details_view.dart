import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hire_me/app/modules/company/company_chat_details/views/widgets/company_message_input.dart';
import 'package:hire_me/app/modules/company/company_chat_details/views/widgets/company_message_list.dart';
import 'package:hire_me/app/modules/job_seeker/chat_details/views/widgets/chat_details_appbar.dart';
import 'package:hire_me/core/utils/app_color.dart';

import '../controllers/company_chat_details_controller.dart';

class CompanyChatDetailsView extends StatelessWidget {
  final String? chatName;
  final String? avatarUrl;
  final String? seekerId;
  final String? companyId;

  const CompanyChatDetailsView({
    super.key,
    this.chatName,
    this.seekerId,
    this.companyId,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    final name = chatName ?? args['chatName'] ?? 'Chat';
    final avatar = avatarUrl ?? args['avatarUrl'] ?? '';
    final sId = seekerId ?? args['seekerId'] ?? '';
    final cId = companyId ?? args['companyId'] ?? '';
    final chatId = args['chatId'] ?? '';

    final controller = Get.put(
      CompanyChatDetailsController(
        chatName: name,
        chatAvatarUrl: avatar,
        chatId: chatId,
        seekerId: sId,
        companyId: cId,
      ),
      tag: name,
    );

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: ChatDetailsAppbar(name: name, avatarUrl: avatar),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return CompanyMessagesList(controller: controller);
            }),
          ),
          CompanyMessageInput(controller: controller),
        ],
      ),
    );
  }
}
