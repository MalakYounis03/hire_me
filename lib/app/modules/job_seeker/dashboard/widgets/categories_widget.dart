import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/core/utils/app_color.dart';
import '../controllers/job_seeker_dashboard_controller.dart';

class CategoriesWidget extends GetView<JobSeekerDashboardController> {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Text(
            "Discover jobs by category",
            style: TextStyle(
              fontWeight: FontWeight.w700, // جعل الخط أسمك كما في فيجما
              fontSize: 18, // تكبير الخط قليلاً
              color: Colors.black.withOpacity(0.8),
            ),
          ),
        ),
        Obx(() {
          if (controller.isCategoriesLoading.value) {
            return const SizedBox(
              height: 140,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return SizedBox(
            height: 150, // زيادة الارتفاع الكلي لاستيعاب المربعات الكبيرة والنص
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                bool isSelected =
                    controller.selectedCategory.value == category.name;

                return GestureDetector(
                  onTap: () => controller.selectCategory(category.name),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 18,
                    ), // مسافة جانبية مريحة
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 105, // ✅ مطابقة لقياس فيجما (109)
                          height: 95, // ✅ مطابقة لقياس فيجما (96)
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            // في فيجما يظهر لون خلفية فاتح جداً عند الاختيار
                            color: isSelected
                                ? const Color(0xFFDEE8F8)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(
                              20,
                            ), // زوايا دائرية أكثر احترافية
                            border: Border.all(
                              color: isSelected
                                  ? AppColor.kblue
                                  : Colors.grey.shade100,
                              width: isSelected ? 1.5 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: category.iconUrl.isNotEmpty
                              ? Image.network(
                                  category.iconUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.category_outlined,
                                        color: AppColor.kblue,
                                      ),
                                )
                              : Icon(
                                  Icons.category_outlined,
                                  color: AppColor.kblue,
                                  size: 35,
                                ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 14, // خط أوضح
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected ? AppColor.kblue : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
