import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_pages.dart';

class AuthSplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 4), () {
      Get.offNamed(Routes.ONBOARDING);
    });
  }
}
