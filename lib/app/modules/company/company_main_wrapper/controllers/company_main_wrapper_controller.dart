import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_pages.dart';

class CompanyMainWrapperController extends GetxController {
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  void onPostJobPressed() {
    Get.toNamed(Routes.COMPANY_POST_JOB);
  }
}
