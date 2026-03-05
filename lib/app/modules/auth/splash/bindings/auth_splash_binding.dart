import 'package:get/get.dart';

import '../controllers/auth_splash_controller.dart';

class AuthSplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthSplashController>(
      () => AuthSplashController(),
    );
  }
}
