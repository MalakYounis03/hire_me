import 'package:flutter/widgets.dart';
import 'package:hire_me/core/utils/app_color.dart';

class ChatInfo extends StatelessWidget {
  final String name;
  final String lastMessage;
  const ChatInfo({required this.name, required this.lastMessage, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColor.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          lastMessage,
          style: const TextStyle(fontSize: 13, color: AppColor.textSecondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
