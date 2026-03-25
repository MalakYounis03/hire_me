import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AuthOnboardingController extends GetxController {
  //TODO: Implement AuthOnboardingController
  final PageController pageController = PageController();
  final count = 0.obs;
  var currentPage = 0.obs;
  void onPageChanged(int index) {
    currentPage.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
