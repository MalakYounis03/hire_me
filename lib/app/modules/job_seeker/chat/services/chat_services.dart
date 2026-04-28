// lib/app/data/services/chat_service.dart
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:hire_me/app/modules/job_seeker/chat/model/chat_model.dart';
import 'package:hire_me/app/modules/job_seeker/chat_details/model/chat_details_model.dart';

class ChatService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // ─────────────────────────────────────────
  // جيب كل الشاتس تبع اليوزر (real-time)
  // ─────────────────────────────────────────
  Stream<List<ChatModel>> getChats(String userId) {
    // ignore: close_sinks
    final controller = StreamController<List<ChatModel>>();

    List<ChatModel> seekerChats = [];
    List<ChatModel> companyChats = [];

    void emit() {
      final result = [...seekerChats, ...companyChats];
      result.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
      controller.add(result);
    }

    _db.child('chats').orderByChild('seekerId').equalTo(userId).onValue.listen((
      event,
    ) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      seekerChats =
          data?.entries
              .map((e) => ChatModel.fromMap(e.key, e.value))
              .toList() ??
          [];
      emit();
    });

    _db.child('chats').orderByChild('companyId').equalTo(userId).onValue.listen(
      (event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        companyChats =
            data?.entries
                .map((e) => ChatModel.fromMap(e.key, e.value))
                .toList() ??
            [];
        emit();
      },
    );

    return controller.stream;
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
  Future<void> sendMessage(
    String chatId,
    ChatDetailsModel message, {
    required String seekerId,
    required String companyId,
    required String currentUserId,
  }) async {
    // 1. احفظ الرسالة
    final ref = _db.child('chats/$chatId/messages').push();
    await ref.set(message.toMap());

    // 2. حدث الـ lastMessage
    await _db.child('chats/$chatId').update({
      'lastMessage': message.text,
      'lastMessageTime': message.time.millisecondsSinceEpoch,
      'lastMessageAuthor': currentUserId,
    });

    // 3. زد unread عند المستلم بس ✅
    final isSeeker = currentUserId == seekerId;
    final unreadField = isSeeker ? 'unreadCompany' : 'unreadSeeker';

    final unreadRef = _db.child('chats/$chatId/$unreadField');
    await unreadRef.runTransaction((value) {
      final current = (value as num?)?.toInt() ?? 0;
      return Transaction.success(current + 1);
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
    required String companyName,
    required String seekerName,
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
      'companyName': companyName,
      'seekerName': seekerName,
    });

    return ref.key!; // ✅ يرجع الـ chatId
  }
}
