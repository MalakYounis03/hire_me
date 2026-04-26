import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/modules/job_seeker/chat/views/widgets/avatar.dart';
import 'package:hire_me/core/utils/app_color.dart';

class ChatDetailsAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String avatarUrl;

  const ChatDetailsAppbar({
    required this.name,
    required this.avatarUrl,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 48);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColor.white,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColor.textPrimary,
                  size: 20,
                ),
                onPressed: () => Get.back(),
              ),
              Avatar(name: name, avatarUrl: avatarUrl, radius: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.search_rounded,
                  color: AppColor.textPrimary,
                  size: 20,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColor.textPrimary,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
