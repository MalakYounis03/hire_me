import 'package:flutter/material.dart';
import 'package:hire_me/app/modules/job_seeker/chat/views/widgets/avatar.dart';
import 'package:hire_me/app/modules/job_seeker/chat_details/model/chat_details_model.dart';
import 'package:hire_me/core/utils/app_color.dart';

class MessageBubble extends StatelessWidget {
  final ChatDetailsModel message;
  final String time;
  final bool isMe; // ✅ بتجي من الكنترولر

  final String senderName; // ✅ أضف
  final String senderAvatarUrl; // ✅ أضف

  const MessageBubble({
    required this.message,
    required this.time,
    required this.isMe, // ✅
    required this.senderName,
    this.senderAvatarUrl = '',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Avatar(
              name: senderName, // ✅
              avatarUrl: senderAvatarUrl, // ✅
              radius: 16,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? AppColor.kblue : AppColor.greyVeryLight,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: isMe ? AppColor.white : AppColor.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColor.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
