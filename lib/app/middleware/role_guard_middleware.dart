import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_pages.dart';
import 'package:hire_me/app/services/storage_service.dart';

class RoleGuardMiddleware extends GetMiddleware {
  RoleGuardMiddleware({required this.requiredRole});

  final String requiredRole;

  @override
  RouteSettings? redirect(String? _) {
    if (!Get.isRegistered<StorageService>()) {
      return const RouteSettings(name: Routes.AUTH_LOGIN);
    }

    final storage = StorageService.to;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null || !storage.isLoggedIn) {
      storage.clearAuthSession();
      return const RouteSettings(name: Routes.AUTH_LOGIN);
    }

    final role = StorageService.normalizeRole(storage.userRole);
    if (role == null) {
      storage.clearAuthSession();
      return const RouteSettings(name: Routes.AUTH_LOGIN);
    }

    if (role != requiredRole) {
      final targetRoute = role == AppUserRole.company.value
          ? Routes.COMPANY_MAIN_WRAPPER
          : Routes.MAIN_WRAPPER;
      return RouteSettings(name: targetRoute);
    }

    return null;
  }
}
