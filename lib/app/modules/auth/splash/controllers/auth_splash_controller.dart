import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_routes.dart';

class AuthSplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(Routes.AUTH_SELECT_USER);
    });
  }
}
