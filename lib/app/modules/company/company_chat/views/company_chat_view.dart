import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:hire_me/app/services/storage_service.dart';
import 'widgets/company_chat_tile.dart';
import 'widgets/company_empty_state.dart';
import '../../../job_seeker/dashboard/widgets/search_widget.dart';
import '../../../../routes/app_pages.dart';
import '../../../../../core/utils/app_color.dart';

import '../controllers/company_chat_controller.dart';

class CompanyChatView extends GetView<CompanyChatController> {
  const CompanyChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 50),
              decoration: BoxDecoration(
                color: AppColor.kblue,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    Text(
                      'Chats',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () async {
                        final auth = FirebaseAuth.instance;
                        final uid = auth.currentUser?.uid;
                        if (uid != null) {
                          final firestore = FirebaseFirestore.instance;
                          final role = StorageService.to.userRole;
                          final roleCollection = role == AppUserRole.company.value
                              ? 'companies'
                              : 'jobSeekers';
                          await firestore.collection(roleCollection).doc(uid).set({
                            'fcmToken': FieldValue.delete(),
                          }, SetOptions(merge: true));
                          await firestore.collection('users').doc(uid).set({
                            'fcmToken': FieldValue.delete(),
                          }, SetOptions(merge: true));
                          await FirebaseMessaging.instance.deleteToken();
                        }
                        await StorageService.to.clearAuthSession();
                        await auth.signOut();
                        Get.offAllNamed(Routes.AUTH_LOGIN);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Search متداخلة مع الهيدر
            Transform.translate(
              offset: const Offset(0, -28),
              child: SearchBarWidget(
                searchController: controller.searchController,
                onChanged: controller.onSearchChanged,
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(), // ✅
                  );
                }
                final chats = controller.filteredChats;
                if (chats.isEmpty) return const CompanyEmptyState();
                return ListView.builder(
                  itemCount: chats.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (_, index) =>
                      CompanyChatTile(chat: chats[index]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
