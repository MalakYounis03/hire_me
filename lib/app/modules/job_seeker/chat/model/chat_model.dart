class ChatModel {
  final String id;
  final String companyId;
  final String seekerId;
  final String jobId;
  final String name;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String avatarUrl;
  final int unreadCount;

  ChatModel({
    required this.id,
    required this.companyId,
    required this.seekerId,
    required this.jobId,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.avatarUrl,
    this.unreadCount = 0,
  });

  factory ChatModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return ChatModel(
      id: id,
      companyId: map['companyId'] ?? '',
      seekerId: map['seekerId'] ?? '',
      jobId: map['jobId'] ?? '',
      name: map['name'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: DateTime.fromMillisecondsSinceEpoch(
        map['lastMessageTime'] ?? 0,
      ),
      avatarUrl: map['avatarUrl'] ?? '',
      unreadCount: map['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'seekerId': seekerId,
      'jobId': jobId,
      'name': name,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.millisecondsSinceEpoch,
      'avatarUrl': avatarUrl,
      'unreadCount': unreadCount,
    };
  }
}
