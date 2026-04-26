class ChatDetailsModel {
  final String id;
  final String text;
  final bool isMe;
  final DateTime time;

  ChatDetailsModel({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
  });
}
