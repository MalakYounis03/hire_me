import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:hire_me/app/modules/job_seeker/chat/views/widgets/chat_tile.dart';
import 'package:hire_me/app/modules/job_seeker/chat/views/widgets/empty_state.dart';
import 'package:hire_me/app/modules/job_seeker/dashboard/widgets/search_widget.dart';
import 'package:hire_me/app/routes/app_pages.dart';
import 'package:hire_me/core/utils/app_color.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

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
                        await FirebaseAuth.instance.signOut();
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
                if (chats.isEmpty) return const EmptyState();
                return ListView.builder(
                  itemCount: chats.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (_, index) => ChatTile(chat: chats[index]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
