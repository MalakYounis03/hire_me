import 'package:get/get.dart';

import '../controllers/chat_details_controller.dart';

class ChatDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatDetailsController>(
      () => ChatDetailsController(
        chatName: Get.parameters['chatName'] ?? 'Chat',
        chatAvatarUrl: Get.parameters['chatAvatarUrl'] ?? '',
        chatId: Get.parameters['chatId'] ?? '',
        seekerId: Get.parameters['seekerId'] ?? '',
        companyId: Get.parameters['companyId'] ?? '',
      ),
    );
  }
}
