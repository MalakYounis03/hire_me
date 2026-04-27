// lib/app/data/services/chat_service.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:hire_me/app/modules/job_seeker/chat/model/chat_model.dart';
import 'package:hire_me/app/modules/job_seeker/chat_details/model/chat_details_model.dart';

class ChatService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // ─────────────────────────────────────────
  // جيب كل الشاتس تبع اليوزر (real-time)
  // ─────────────────────────────────────────
  Stream<List<ChatModel>> getChats(String userId) {
    return _db
        .child('chats')
        .orderByChild('seekerId')
        .equalTo(userId)
        .onValue
        .map((event) {
          final data = event.snapshot.value as Map<dynamic, dynamic>?;
          if (data == null) return [];

          return data.entries
              .map((e) => ChatModel.fromMap(e.key, e.value))
              .toList()
            ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
        });
  }

  // ─────────────────────────────────────────
  // جيب الرسائل (real-time)
  // ─────────────────────────────────────────
  Stream<List<ChatDetailsModel>> getMessages(String chatId) {
    return _db.child('chats/$chatId/messages').orderByChild('time').onValue.map(
      (event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data == null) return [];

        return data.entries
            .map((e) => ChatDetailsModel.fromMap(e.key, e.value))
            .toList()
          ..sort((a, b) => a.time.compareTo(b.time));
      },
    );
  }

  // ─────────────────────────────────────────
  // ارسل رسالة
  // ─────────────────────────────────────────
  Future<void> sendMessage(String chatId, ChatDetailsModel message) async {
    final ref = _db.child('chats/$chatId/messages').push();
    await ref.set(message.toMap());

    // ✅ حدّث الـ lastMessage بالـ chat
    await _db.child('chats/$chatId').update({
      'lastMessage': message.text,
      'lastMessageTime': message.time.millisecondsSinceEpoch,
    });
  }

  // ─────────────────────────────────────────
  // إنشاء chat جديد (بس لما status = Accepted)
  // ─────────────────────────────────────────
  Future<String> createChat({
    required String companyId,
    required String seekerId,
    required String jobId,
    required String name,
    required String avatarUrl,
  }) async {
    final ref = _db.child('chats').push();

    await ref.set({
      'companyId': companyId,
      'seekerId': seekerId,
      'jobId': jobId,
      'name': name,
      'avatarUrl': avatarUrl,
      'lastMessage': '',
      'lastMessageTime': DateTime.now().millisecondsSinceEpoch,
      'unreadCount': 0,
    });

    return ref.key!; // ✅ يرجع الـ chatId
  }
}
