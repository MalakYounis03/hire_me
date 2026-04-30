import 'package:get/get.dart';

import '../controllers/company_chat_details_controller.dart';

class CompanyChatDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompanyChatDetailsController>(
      () => CompanyChatDetailsController(
        chatName: Get.parameters['chatName'] ?? 'Chat',
        chatAvatarUrl: Get.parameters['chatAvatarUrl'] ?? '',
        chatId: Get.parameters['chatId'] ?? '',
        seekerId: Get.parameters['seekerId'] ?? '',
        companyId: Get.parameters['companyId'] ?? '',
      ),
    );
  }
}
