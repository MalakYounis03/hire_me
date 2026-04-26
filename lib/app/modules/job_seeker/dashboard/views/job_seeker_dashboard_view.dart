import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/core/utils/app_color.dart';
import 'package:hire_me/app/core/utils/app_text_style.dart';
import 'package:hire_me/app/modules/job_seeker/dashboard/controllers/job_seeker_dashboard_controller.dart';
import 'package:hire_me/app/modules/job_seeker/dashboard/widgets/header_widget.dart';
import 'package:hire_me/app/modules/job_seeker/dashboard/widgets/search_widget.dart';
import 'package:hire_me/app/modules/job_seeker/dashboard/widgets/job_card_widget.dart';

class JobSeekerDashboardView extends GetView<JobSeekerDashboardController> {
  const JobSeekerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // لون الخلفية المريح من الفيجما
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
                // 1. الهيدر الأزرق المنحني (يحتوي على اسم المستخدم الحقيقي)
                const HeaderWidget(),

                // 2. شريط البحث (المتداخل مع الهيدر)
                const SearchWidget(),

                // 3. قسم التصنيفات (Categories)
                _buildCategorySection(),

                // 4. عنوان قسم الوظائف
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

                // 5. قائمة الوظائف (تتحدث تلقائياً مع الفلترة والفايربيز)
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

  // ويلجت عرض الفئات بشكل أفقي
  Widget _buildCategorySection() {
    final categories = ['الكل', 'Mobile', 'Web', 'Design', 'Backend'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Text(
            "Categories",
            style: CustomTextstyle.Poppinssemibold.copyWith(fontSize: 16),
          ),
        ),
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Obx(() {
                bool isSelected =
                    controller.selectedCategory.value == categories[index];
                return GestureDetector(
                  onTap: () => controller.selectCategory(categories[index]),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColor.kblue : AppColor.kwhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColor.kblue
                            : AppColor.greyVeryLight,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColor.greydark,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }

  // واجهة تظهر عند عدم وجود نتائج
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
