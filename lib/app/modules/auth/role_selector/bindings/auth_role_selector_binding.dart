import 'package:get/get.dart';

import '../controllers/auth_role_selector_controller.dart';

class AuthRoleSelectorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRoleSelectorController>(
      () => AuthRoleSelectorController(),
    );
  }
}
