import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';
import 'package:hire_me/app/modules/job_seeker/chat_details/controllers/chat_details_controller.dart';
import 'package:hire_me/app/modules/job_seeker/chat_details/views/widgets/data_divider.dart';
import 'package:hire_me/app/modules/job_seeker/chat_details/views/widgets/message_bubble.dart';

class MessagesList extends StatelessWidget {
  final ChatDetailsController controller;
  const MessagesList({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: controller.messages.length,
        itemBuilder: (_, index) {
          final msg = controller.messages[index];
          return Column(
            children: [
              if (controller.showDateDivider(index))
                DateDivider(label: controller.formatDate(msg.time)),
              MessageBubble(
                message: msg,
                time: controller.formatTime(msg.time),
                senderName: controller.chatName, // اسم الشخص الثاني
                senderAvatarUrl: controller.chatAvatarUrl,
              ),
            ],
          );
        },
      ),
    );
  }
}
