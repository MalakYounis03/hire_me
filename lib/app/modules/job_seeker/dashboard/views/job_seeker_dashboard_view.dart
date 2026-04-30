import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/core/utils/app_color.dart';
import 'package:hire_me/app/core/utils/app_text_style.dart';
import 'package:hire_me/app/modules/job_seeker/dashboard/controllers/job_seeker_dashboard_controller.dart';
import 'package:hire_me/app/modules/job_seeker/dashboard/widgets/header_widget.dart';
import 'package:hire_me/app/modules/job_seeker/dashboard/widgets/search_widget.dart';
import 'package:hire_me/app/modules/job_seeker/dashboard/widgets/job_card_widget.dart';
import 'package:hire_me/app/modules/job_seeker/dashboard/widgets/categories_widget.dart';

class JobSeekerDashboardView extends GetView<JobSeekerDashboardController> {
  const JobSeekerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.refreshDashboard(),
          color: AppColor.kblue,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidget(),

                Transform.translate(
                  offset: const Offset(0, -28),
                  child: SearchBarWidget(
                    searchController: TextEditingController(),
                    onChanged: (value) => controller.onSearch(value),
                  ),
                ),

                // ✅ التعديل هنا: استخدام الـ Widget الجديد بدلاً من الدالة القديمة
                const CategoriesWidget(),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Jobs",
                        style: CustomTextstyle.Poppinsbold.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "See All",
                          style: TextStyle(
                            color: AppColor.kblue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Obx(() {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (controller.filteredJobs.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: controller.filteredJobs.length,
                    itemBuilder: (context, index) {
                      final job = controller.filteredJobs[index];
                      return JobCardWidget(job: job);
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ يمكنكِ الآن حذف دالة _buildCategorySection القديمة تماماً لتنظيف الكود

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 80, color: AppColor.greyLight),
            const SizedBox(height: 10),
            Text(
              "No jobs found!",
              style: CustomTextstyle.Poppins500grey.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
