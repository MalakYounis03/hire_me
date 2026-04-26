import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MainWrapperController extends GetxController {
  var currentIndex = 0.obs; // متغير مراقب لتبديل الصفحات

  void changePage(int index) {
    currentIndex.value = index;
  }
}
