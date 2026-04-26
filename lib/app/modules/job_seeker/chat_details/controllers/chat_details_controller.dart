import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/modules/job_seeker/chat/services/chat_services.dart';
import 'package:hire_me/app/modules/job_seeker/chat_details/model/chat_details_model.dart';

class ChatDetailsController extends GetxController {
  final String chatId;
  final String chatName;
  final String chatAvatarUrl;

  ChatDetailsController({
    required this.chatId, // ✅ محتاج chatId هلق
    required this.chatName,
    this.chatAvatarUrl = '',
  });

  final ChatService _chatService = ChatService();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final RxBool hasText = false.obs;
  final RxBool isLoading = true.obs;
  final RxList<ChatDetailsModel> messages = <ChatDetailsModel>[].obs;

  bool isMe(String senderId) => senderId == currentUserId;

  @override
  void onInit() {
    super.onInit();
    _listenToMessages();
  }

  void _listenToMessages() {
    _chatService.getMessages(chatId).listen((msgs) {
      messages.value = msgs;
      isLoading.value = false;

      // ✅ سكرول للأسفل لما تيجي رسائل جديدة
      Future.delayed(const Duration(milliseconds: 100), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final message = ChatDetailsModel(
      id: '',
      text: text,
      senderId: currentUserId,
      time: DateTime.now(),
    );

    messageController.clear();
    hasText.value = false;

    await _chatService.sendMessage(chatId, message);
  }

  void onTextChanged(String value) {
    hasText.value = value.trim().isNotEmpty;
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
