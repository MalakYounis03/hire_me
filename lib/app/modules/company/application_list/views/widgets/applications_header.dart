import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/core/utils/app_color.dart';

class ApplicantsHeader extends StatelessWidget {
  final String jobTitle;
  const ApplicantsHeader({required this.jobTitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 50, 25, 20),
      decoration: BoxDecoration(
        color: AppColor.kblue,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColor.kwhite,
                    size: 22,
                  ),
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                ),
                const Spacer(),
                Icon(
                  Icons.notifications_none_rounded,
                  color: AppColor.kwhite,
                  size: 26,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Applicants List',
              style: TextStyle(
                color: AppColor.kwhite,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              jobTitle,
              style: TextStyle(
                color: AppColor.kwhite.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
