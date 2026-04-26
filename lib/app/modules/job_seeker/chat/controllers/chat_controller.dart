import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/modules/job_seeker/chat/model/chat_model.dart';

class ChatController extends GetxController {
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  final RxList<ChatModel> allChats = <ChatModel>[
    ChatModel(
      id: '1',
      name: 'Bryan',
      lastMessage: 'What do you think?',
      time: '4:30 PM',
      avatarUrl: '',
      unreadCount: 2,
    ),
    ChatModel(
      id: '2',
      name: 'Kari',
      lastMessage: 'Looks great!',
      time: '4:23 PM',
      avatarUrl: '',
      unreadCount: 1,
    ),
    ChatModel(
      id: '3',
      name: 'Diana',
      lastMessage: 'Lunch on Monday?',
      time: '4:12 PM',
      avatarUrl: '',
      unreadCount: 0,
    ),
    ChatModel(
      id: '4',
      name: 'Ben',
      lastMessage: 'You sent a photo.',
      time: '3:58 PM',
      avatarUrl: '',
      unreadCount: 0,
    ),
    ChatModel(
      id: '5',
      name: 'Alicia',
      lastMessage: 'See you at 8.',
      time: '3:30 PM',
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
