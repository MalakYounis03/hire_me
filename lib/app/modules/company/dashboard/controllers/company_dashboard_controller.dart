import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/notification_repository.dart';
import '../../../../routes/app_pages.dart';

class CompanyDashboardController extends GetxController {
  final unreadCount = 0.obs;
  StreamSubscription? _notificationsSub;

  final _auth = FirebaseAuth.instance;
  final _repository = NotificationRepository();

  @override
  void onInit() {
    super.onInit();
    _listenToUnreadCount();
  }

  void _listenToUnreadCount() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    _notificationsSub = _repository.streamNotifications(uid).listen((snapshot) {
      final docs = snapshot.docs;
      int count = 0;
      for (final doc in docs) {
        final isRead = doc.data()['isRead'] as bool? ?? false;
        if (!isRead) count++;
      }
      unreadCount.value = count;
    });
  }

  void onNotificationsTap() {
    Get.toNamed(Routes.COMPANY_NOTIFICATIONS);
  }

  @override
  void onClose() {
    _notificationsSub?.cancel();
    super.onClose();
  }
}
