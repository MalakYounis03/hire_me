import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class CompanyMainWrapperController extends GetxController {
  final currentIndex = 2.obs; // Dashboard default
  final unreadChats = 0.obs;

  StreamSubscription? _chatSub;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      final initialIndex = args['initialIndex'];

      if (initialIndex is int && initialIndex >= 0 && initialIndex <= 3) {
        currentIndex.value = initialIndex;
      }
    }

    _listenToUnreadChats();
  }

  void _listenToUnreadChats() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    _chatSub = FirebaseDatabase.instance
        .ref()
        .child('chats')
        .orderByChild('companyId')
        .equalTo(uid)
        .onValue
        .map((event) {
          final data = event.snapshot.value as Map<dynamic, dynamic>?;
          if (data == null) return 0;
          return data.entries.where((e) {
            final chat = e.value as Map<dynamic, dynamic>;
            return ((chat['unreadCompany'] as num?)?.toInt() ?? 0) > 0;
          }).length;
        })
        .listen((c) => unreadChats.value = c);
  }

  void changePage(int index) {
    if (index == currentIndex.value) return;
    currentIndex.value = index;
  }

  void goToDashboard() {
    currentIndex.value = 2;
  }

  void goToPostJob() {
    currentIndex.value = 3;
  }

  @override
  void onClose() {
    _chatSub?.cancel();
    super.onClose();
  }
}
