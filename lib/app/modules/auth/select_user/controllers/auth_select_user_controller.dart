import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_pages.dart';

class AuthSelectUserController extends GetxController {
  @override
  final selectedRole = ''.obs;

  void selectRole(String role) {
    selectedRole.value = role;
  }

  void onNextPressed() {
    if (selectedRole.value.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'الرجاء اختيار نوع المستخدم أولاً',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1A3794),
        colorText: const Color(0xFFFFFFFF),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    Get.toNamed(Routes.AUTH_REGISTER, arguments: {'role': selectedRole.value});
  }
}
