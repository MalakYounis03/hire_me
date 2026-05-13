import 'package:get/get.dart';

class CompanyMainWrapperController extends GetxController {
  final currentIndex = 2.obs; // Dashboard default

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      final initialIndex = args['initialIndex'];

      if (initialIndex is int && initialIndex >= 0 && initialIndex <= 3) {
        currentIndex.value = initialIndex;
      }
    }
  }

  void changePage(int index) {
    if (index == currentIndex.value) return;
    currentIndex.value = index;
  }

  void goToDashboard() {
    currentIndex.value = 2;
  }

  void goToPostJob() {
    currentIndex.value = 3;
  }
}
