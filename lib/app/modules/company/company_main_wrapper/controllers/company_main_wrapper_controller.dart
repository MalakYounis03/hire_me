import 'package:get/get.dart';

class CompanyMainWrapperController extends GetxController {
  final currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      final initialIndex = args['initialIndex'];

      if (initialIndex is int && initialIndex >= 0 && initialIndex <= 4) {
        currentIndex.value = initialIndex;
      }
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  void onPostJobPressed() {
    currentIndex.value = 2;
  }
}
