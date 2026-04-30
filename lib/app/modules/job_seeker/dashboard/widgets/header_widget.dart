// lib/app/modules/job_seeker/dashboard/widgets/header_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/core/utils/app_color.dart';
import 'package:hire_me/app/core/utils/app_text_style.dart';

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
                style: CustomTextstyle.Poppinssemiboldwhite.copyWith(
                  fontSize: 16,
                  color: AppColor.kwhite.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Find the right job\nfor your skills",
                style: CustomTextstyle.Poppinsbold.copyWith(
                  color: AppColor.kwhite,
                  fontSize: 24,
                  height: 1.1,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.kwhite.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              color: AppColor.kwhite,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
