import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthSplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 4), () => _navigate());
  }

  Future<void> _navigate() async {
    final prefs = await SharedPreferences.getInstance();
    final bool seenOnboarding = prefs.getBool('seen_onboarding') ?? false;
    final User? user = FirebaseAuth.instance.currentUser;

    if (!seenOnboarding) {
      // أول مرة يفتح التطبيق → Onboarding
      Get.offNamed(Routes.ONBOARDING);
    } else if (user == null) {
      // شاف الـ Onboarding قبل بس ما سجل دخول (أو عمل logout) → Login
      Get.offNamed(Routes.AUTH_LOGIN);
    } else {
      // مسجل دخول → روح عالتطبيق مباشرة
      // عدّل الـ route حسب نوع المستخدم لو عندك logic لهيك
      Get.offNamed(Routes.MAIN_WRAPPER);
    }
  }
}
