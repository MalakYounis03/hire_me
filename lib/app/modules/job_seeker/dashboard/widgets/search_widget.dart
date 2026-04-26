// lib/app/modules/job_seeker/dashboard/widgets/search_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/core/utils/app_color.dart';
import '../controllers/job_seeker_dashboard_controller.dart';

class SearchWidget extends GetView<JobSeekerDashboardController> {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Transform.translate(
        offset: const Offset(0, -28),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: AppColor.kwhite,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.kblue.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) => controller.onSearch(value),
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(
                      color: AppColor.greyLight,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColor.greyLight,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: AppColor.kwhite,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.kblue.withOpacity(0.1),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Icon(Icons.tune_rounded, color: AppColor.kblue),
            ),
          ],
        ),
      ),
    );
  }
}
