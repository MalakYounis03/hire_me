import 'package:get/get.dart';

class MainWrapperController extends GetxController {
  final currentIndex = 2.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map && args['initialIndex'] is int) {
      currentIndex.value = args['initialIndex'];
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
}
