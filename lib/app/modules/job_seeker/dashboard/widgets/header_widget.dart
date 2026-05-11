// lib/app/modules/job_seeker/dashboard/widgets/header_widget.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/core/utils/app_color.dart';
import 'package:hire_me/core/utils/app_text_style.dart';
import 'package:hire_me/app/routes/app_pages.dart';

import '../controllers/job_seeker_dashboard_controller.dart';

class HeaderWidget extends GetView<JobSeekerDashboardController> {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 50, 25, 70),
      decoration: BoxDecoration(
        color: AppColor.kblue,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello,",
                style: CustomTextstyle.poppinsSemiBoldWhite.copyWith(
                  fontSize: 16,
                  color: AppColor.kwhite.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Find the right job\nfor your skills",
                style: CustomTextstyle.poppinsBold.copyWith(
                  color: AppColor.kwhite,
                  fontSize: 24,
                  height: 1.1,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed(Routes.AUTH_LOGIN);
            },
          ),
          Obx(
            () => GestureDetector(
              onTap: () => Get.toNamed(Routes.JOB_SEEKER_NOTIFICATIONS),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.kwhite.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  if (controller.notificationBadgeCount.value > 0)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          controller.notificationBadgeCount.value > 99
                              ? '99+'
                              : '${controller.notificationBadgeCount.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
