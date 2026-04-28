import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/core/utils/app_color.dart';

class ReviewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ReviewAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.kwhite,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColor.kblack),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Applicant Detail',
        style: TextStyle(
          color: AppColor.kblack,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_none_rounded, color: AppColor.kblack),
          onPressed: () {},
        ),
      ],
    );
  }
}
