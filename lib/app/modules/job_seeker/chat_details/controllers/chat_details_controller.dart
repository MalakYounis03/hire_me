import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hire_me/app/modules/job_seeker/chat/services/chat_services.dart';
import 'package:hire_me/app/modules/job_seeker/chat_details/model/chat_details_model.dart';

class ChatDetailsController extends GetxController {
  final String chatId;
  final String chatName;
  final String chatAvatarUrl;
  final String seekerId;
  final String companyId;

  ChatDetailsController({
    required this.chatId,
    required this.chatName,
    this.chatAvatarUrl = '',
    required this.seekerId,
    required this.companyId,
  });

  final ChatService _chatService = ChatService();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final RxBool hasText = false.obs;
  final RxBool isLoading = true.obs;
  final RxList<ChatDetailsModel> messages = <ChatDetailsModel>[].obs;
  final RxInt otherLastSeen = 0.obs; // ✅ آخر وقت شاف فيه الثاني
  final RxString selectedMessageId = ''.obs; // ✅
  bool isMe(String senderId) => senderId == currentUserId;

  @override
  void onInit() {
    super.onInit();
    _listenToMessages();
    _markChatAsRead();
    _markSeen();
    _listenToOtherSeen();
  }

  void _listenToMessages() {
    _chatService.getMessages(chatId).listen((msgs) {
      messages.value = msgs;
      isLoading.value = false;
      _markSeen();

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

    await _chatService.sendMessage(
      chatId,
      message,
      seekerId: seekerId,
      companyId: companyId,
      currentUserId: currentUserId,
    );
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

  Future<void> _markChatAsRead() async {
    final isSeeker = currentUserId == seekerId;
    final unreadField = isSeeker ? 'unreadSeeker' : 'unreadCompany';

    await FirebaseDatabase.instance
        .ref()
        .child('chats/$chatId/$unreadField')
        .set(0);
  }

  Future<void> _markSeen() async {
    await FirebaseDatabase.instance
        .ref()
        .child('chats/$chatId/meta/lastSeenBy/$currentUserId')
        .set(DateTime.now().millisecondsSinceEpoch);
  }

  void _listenToOtherSeen() {
    final otherId = currentUserId == seekerId ? companyId : seekerId;

    FirebaseDatabase.instance
        .ref()
        .child('chats/$chatId/meta/lastSeenBy/$otherId')
        .onValue
        .listen((event) {
          final val = event.snapshot.value;
          otherLastSeen.value = (val as num?)?.toInt() ?? 0;
        });
  }

  void toggleMessageTime(String messageId) {
    if (selectedMessageId.value == messageId) {
      selectedMessageId.value = '';
    } else {
      selectedMessageId.value = messageId;
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
