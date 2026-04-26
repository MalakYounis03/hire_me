import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/modules/job_seeker/chat_details/model/chat_details_model.dart';

class ChatDetailsController extends GetxController {
  final String chatName;
  final String chatAvatarUrl;

  ChatDetailsController({required this.chatName, this.chatAvatarUrl = ''});

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final RxBool hasText = false.obs;
  late final RxList<ChatDetailsModel> messages = <ChatDetailsModel>[
    ChatDetailsModel(
      id: '1',
      text: 'Looking forward to the trip.',
      senderId: 'other_user_id',
      time: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    ChatDetailsModel(
      id: '2',
      text: "Same! Can't wait.",
      senderId: currentUserId,
      time: DateTime.now().subtract(const Duration(minutes: 9)),
    ),
    ChatDetailsModel(
      id: '3',
      text: 'What do you think?',
      senderId: 'other_user_id',
      time: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    ChatDetailsModel(
      id: '4',
      text: 'Oh yes this looks great!',
      senderId: currentUserId,
      time: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ].obs;

  // ✅ هون بتعرف إذا الرسالة تبعك أو لأ
  bool isMe(String senderId) => senderId == currentUserId;

  void onTextChanged(String value) {
    hasText.value = value.trim().isNotEmpty;
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messages.add(
      ChatDetailsModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        senderId: currentUserId, // ✅ بدل isMe: true
        time: DateTime.now(),
      ),
    );

    messageController.clear();
    hasText.value = false;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool showDateDivider(int index) {
    if (index == 0) return true;
    final prev = messages[index - 1].time;
    final curr = messages[index].time;
    return prev.day != curr.day;
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
