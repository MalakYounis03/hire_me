import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_pages.dart';

class JobSeekerDashboardController extends GetxController {
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.SPLASH);
  }
}
