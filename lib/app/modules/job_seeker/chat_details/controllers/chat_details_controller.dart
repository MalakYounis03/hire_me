import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/modules/job_seeker/chat_details/model/chat_details_model.dart';

class ChatDetailsController extends GetxController {
  final String chatName;
  final String chatAvatarUrl;

  ChatDetailsController({required this.chatName, this.chatAvatarUrl = ''});

  final messageController = TextEditingController();
  final scrollController = ScrollController();

  final RxList<ChatDetailsModel> messages = <ChatDetailsModel>[
    ChatDetailsModel(
      id: '1',
      text: 'Looking forward to the trip.',
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    ChatDetailsModel(
      id: '2',
      text: "Same! Can't wait.",
      isMe: true,
      time: DateTime.now().subtract(const Duration(minutes: 9)),
    ),
    ChatDetailsModel(
      id: '3',
      text: 'What do you think?',
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    ChatDetailsModel(
      id: '4',
      text: 'Oh yes this looks great!',
      isMe: true,
      time: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ].obs;

  final RxBool hasText = false.obs;

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
        isMe: true,
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

  String formatTime(DateTime time) {
    final h = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final m = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  bool showDateDivider(int index) {
    if (index == 0) return true;
    final prev = messages[index - 1].time;
    final curr = messages[index].time;
    return prev.day != curr.day;
  }

  String formatDate(DateTime time) {
    final now = DateTime.now();
    if (time.day == now.day) return 'Today ${formatTime(time)}';
    return '${time.day}/${time.month}/${time.year}';
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
