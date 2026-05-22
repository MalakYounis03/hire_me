import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/modules/job_seeker/dashboard/views/widgets/filter_section_widget.dart';
import 'package:hire_me/core/utils/app_color.dart';
import 'package:hire_me/core/utils/app_text_style.dart';

import '../../controllers/job_seeker_dashboard_controller.dart';

class JobFilterBottomSheet extends GetView<JobSeekerDashboardController> {
  const JobFilterBottomSheet({super.key});

  static void show() {
    Get.bottomSheet(const JobFilterBottomSheet(), isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Obx(
        () => SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BottomSheetHandle(),

              const SizedBox(height: 22),

              Text(
                'Filter Jobs',
                style: CustomTextstyle.poppinsBold.copyWith(fontSize: 20),
              ),

              const SizedBox(height: 20),

              FilterSectionWidget(
                title: 'Job Type',
                items: controller.jobTypes,
                selectedValue: controller.selectedJobType.value,
                onItemTap: controller.setJobTypeFilter,
              ),

              const SizedBox(height: 22),

              FilterSectionWidget(
                title: 'Work Mode',
                items: controller.workModes,
                selectedValue: controller.selectedWorkMode.value,
                onItemTap: controller.setWorkModeFilter,
              ),

              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.clearFilters,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColor.kblue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Clear',
                        style: TextStyle(color: AppColor.kblue),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: Get.back,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.kblue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Apply',
                        style: TextStyle(color: AppColor.kwhite),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
