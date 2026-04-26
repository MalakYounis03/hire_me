import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/job_seeker_dashboard_controller.dart';

class CategoriesWidget extends GetView<JobSeekerDashboardController> {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // الأيقونات والألوان بناءً على تصميم Figma الخاص بكِ
    final List<Map<String, dynamic>> categoriesData = [
      {
        'name': 'Design',
        'icon': Icons.palette_outlined,
        'color': Colors.orange,
      },
      {'name': 'Programming', 'icon': Icons.code, 'color': Colors.blue},
      {'name': 'Data Entry', 'icon': Icons.storage, 'color': Colors.teal},
      {'name': 'Cyber', 'icon': Icons.security, 'color': Colors.red},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Text(
            "Discover jobs by category",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(
          height: 110, // زيادة الطول قليلاً لاستيعاب النص والأيقونة بشكل مريح
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categoriesData.length,
            itemBuilder: (context, index) {
              final cat = categoriesData[index];

              return GestureDetector(
                onTap: () => controller.selectCategory(cat['name']),
                child: Obx(() {
                  // التحقق إذا كانت هذه الفئة هي المختارة حالياً
                  bool isSelected =
                      controller.selectedCategory.value == cat['name'];

                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            // إضافة حدود ملونة وظل خفيف عند الاختيار لتعزيز تجربة المستخدم
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF1546A0)
                                  : Colors.grey.shade100,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Icon(
                            cat['icon'],
                            color: isSelected
                                ? const Color(0xFF1546A0)
                                : cat['color'],
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat['name'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? const Color(0xFF1546A0)
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }
}
