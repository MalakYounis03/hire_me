import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_pages.dart';

class AuthSplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    await Future.delayed(const Duration(seconds: 3));

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.offAllNamed(Routes.ONBOARDING);
    } else {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final role = doc.data()?['role'] as String? ?? 'jobseeker';

      if (role == 'company') {
        Get.offAllNamed(Routes.COMPANY_DASHBOARD);
      } else {
        Get.offAllNamed(Routes.JOB_SEEKER_DASHBOARD);
      }
    }
  }
}
