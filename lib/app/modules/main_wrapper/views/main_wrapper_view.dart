import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/core/utils/app_color.dart';
import 'package:hire_me/app/modules/job_seeker/chat/views/chat_view.dart';
import 'package:hire_me/app/modules/job_seeker/dashboard/views/job_seeker_dashboard_view.dart';
import 'package:hire_me/app/modules/main_wrapper/controllers/main_wrapper_controller.dart';

class MainWrapperView extends GetView<MainWrapperController> {
  const MainWrapperView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // الـ IndexedStack يحافظ على حالة الصفحات (مثلاً مكان السكرول في الداشبورد)
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            const JobSeekerDashboardView(),
            const ChatView(),
            const Center(child: Text("Portfolio Page")),
            const Center(child: Text("Profile Page")),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          // إضافة ظل ناعم جداً لفصل الـ Bar عن المحتوى (مثل الفيجما)
          decoration: BoxDecoration(
            color: AppColor.kwhite,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: BottomNavigationBar(
                currentIndex: controller.currentIndex.value,
                onTap: controller.changePage,
                type: BottomNavigationBarType.fixed,
                backgroundColor:
                    Colors.transparent, // شفاف لأننا نستخدم لون الـ Container
                elevation: 0,
                selectedItemColor: AppColor.kblue,
                unselectedItemColor: AppColor.greyLight,
                showSelectedLabels: false, // إخفاء النصوص تماماً
                showUnselectedLabels: false,
                items: [
                  _buildNavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: "Home",
                  ),
                  _buildNavItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    activeIcon: Icons.chat_bubble_rounded,
                    label: "Chat",
                  ),
                  _buildNavItem(
                    icon: Icons.work_outline_rounded,
                    activeIcon: Icons.work_rounded,
                    label: "Jobs",
                  ),
                  _buildNavItem(
                    icon: Icons.person_outline_rounded,
                    activeIcon: Icons.person_rounded,
                    label: "Profile",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لبناء عناصر الـ Bar بدقة عالية
  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 26),
      activeIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColor.kblue.withOpacity(
            0.1,
          ), // خلفية خفيفة عند الاختيار (اختياري)
          shape: BoxShape.circle,
        ),
        child: Icon(activeIcon, size: 26),
      ),
      label: label,
    );
  }
}
