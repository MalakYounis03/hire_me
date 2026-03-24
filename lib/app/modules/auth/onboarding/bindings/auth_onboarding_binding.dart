import 'package:get/get.dart';

import '../controllers/auth_onboarding_controller.dart';

class AuthOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthOnboardingController>(
      () => AuthOnboardingController(),
    );
  }
}
