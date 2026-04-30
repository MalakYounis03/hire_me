import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_pages.dart';
import 'package:hire_me/app/services/storage_service.dart';

class AuthSplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    try {
      await Future.delayed(const Duration(seconds: 3));

      final storage = StorageService.to;

      if (storage.isFirstTime) {
        Get.offAllNamed(Routes.ONBOARDING);
        return;
      }

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        await storage.clearAuthSession();
        Get.offAllNamed(Routes.AUTH_LOGIN);
        return;
      }

      final cachedRole = StorageService.normalizeRole(storage.userRole);
      final role = cachedRole ?? await _loadRoleFromFirestore(user.uid);

      if (role == null) {
        await storage.clearAuthSession();
        await FirebaseAuth.instance.signOut();
        Get.offAllNamed(Routes.AUTH_LOGIN);
        return;
      }

      await storage.saveAuthSession(
        userId: user.uid,
        role: role,
        accessToken: await user.getIdToken(),
        companyId: role == AppUserRole.company.value ? user.uid : null,
        jobSeekerId: role == AppUserRole.job_seeker.value ? user.uid : null,
      );

      if (role == AppUserRole.company.value) {
        Get.offAllNamed(Routes.COMPANY_MAIN_WRAPPER);
      } else {
        Get.offAllNamed(Routes.MAIN_WRAPPER);
      }
    } catch (_) {
      await FirebaseAuth.instance.signOut();
      if (Get.isRegistered<StorageService>()) {
        await StorageService.to.clearAuthSession();
      }
      Get.offAllNamed(Routes.AUTH_LOGIN);
    }
  }

  Future<String?> _loadRoleFromFirestore(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return StorageService.normalizeRole(doc.data()?['role'] as String?);
  }
}
