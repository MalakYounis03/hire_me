class ChatModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final int unreadCount;

  ChatModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    this.unreadCount = 0,
  });
}
