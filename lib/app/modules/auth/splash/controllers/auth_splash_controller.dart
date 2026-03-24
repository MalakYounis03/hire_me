import 'package:get/get.dart';

class AuthSplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!isClosed) {
      Get.offAllNamed('/select-user');
    }
  }
}
