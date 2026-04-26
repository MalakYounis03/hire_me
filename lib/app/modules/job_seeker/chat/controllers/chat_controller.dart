import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/modules/job_seeker/chat/model/chat_model.dart';

class ChatController extends GetxController {
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  final RxList<ChatModel> allChats = <ChatModel>[
    ChatModel(
      id: '1',
      companyId: 'company_1',
      seekerId: 'seeker_1',
      jobId: 'job_1',
      name: 'Bryan',
      lastMessage: 'What do you think?',
      lastMessageTime: DateTime.now().subtract(
        const Duration(minutes: 10),
      ), // ✅
      avatarUrl: '',
      unreadCount: 2,
    ),
    ChatModel(
      id: '2',
      companyId: 'company_2',
      seekerId: 'seeker_2',
      jobId: 'job_2',
      name: 'Kari',
      lastMessage: 'Looks great!',
      lastMessageTime: DateTime.now().subtract(
        const Duration(minutes: 30),
      ), // ✅
      avatarUrl: '',
      unreadCount: 1,
    ),
    ChatModel(
      id: '3',
      companyId: 'company_3',
      seekerId: 'seeker_3',
      jobId: 'job_3',
      name: 'Diana',
      lastMessage: 'Lunch on Monday?',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)), // ✅
      avatarUrl: '',
      unreadCount: 0,
    ),
    ChatModel(
      id: '4',
      companyId: 'company_4',
      seekerId: 'seeker_4',
      jobId: 'job_4',
      name: 'Ben',
      lastMessage: 'You sent a photo.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)), // ✅
      avatarUrl: '',
      unreadCount: 0,
    ),
    ChatModel(
      id: '5',
      companyId: 'company_5',
      seekerId: 'seeker_5',
      jobId: 'job_5',
      name: 'Alicia',
      lastMessage: 'See you at 8.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)), // ✅
      avatarUrl: '',
      unreadCount: 0,
    ),
  ].obs;

  List<ChatModel> get filteredChats {
    if (searchQuery.value.isEmpty) return allChats;
    return allChats
        .where(
          (c) => c.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
