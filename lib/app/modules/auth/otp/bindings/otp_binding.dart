import 'package:get/get.dart';
import 'package:hire_me/app/modules/auth/otp/controllers/otp_controller.dart';

class AuthOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthOtpController>(() => AuthOtpController());
  }
}