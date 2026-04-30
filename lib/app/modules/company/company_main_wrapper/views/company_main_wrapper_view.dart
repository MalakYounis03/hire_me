import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/core/utils/app_color.dart';
import 'package:hire_me/app/modules/company/application_list/views/application_list_view.dart';
import 'package:hire_me/app/modules/company/company_chat/views/company_chat_view.dart';
import 'package:hire_me/app/modules/company/company_profile/views/company_profile_view.dart';
import 'package:hire_me/app/modules/company/dashboard/views/company_dashboard_view.dart';
import '../controllers/company_main_wrapper_controller.dart';

class CompanyMainWrapperView extends GetView<CompanyMainWrapperController> {
  const CompanyMainWrapperView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            CompanyDashboardView(),
            ApplicationListView(),
            CompanyChatView(),
            CompanyProfileView(),
          ],
        ),
      ),

      // الـ FAB في المنتصف لـ Post Job
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onPostJobPressed,
        backgroundColor: AppColor.kblue,
        shape: const CircleBorder(),
        elevation: 4,
        child: Icon(Icons.add_rounded, color: AppColor.kwhite, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColor.kwhite,
          boxShadow: [
            BoxShadow(
              color: AppColor.kblack.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: BottomAppBar(
              color: Colors.transparent,
              elevation: 0,
              notchMargin: 8,
              shape: const CircularNotchedRectangle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Dashboard
                  _buildNavItem(
                    index: 0,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: 'Home',
                  ),
                  // Applications
                  _buildNavItem(
                    index: 1,
                    icon: Icons.description_outlined,
                    activeIcon: Icons.description_rounded,
                    label: 'Applications',
                  ),

                  // مكان فارغ للـ FAB في المنتصف
                  const SizedBox(width: 48),

                  // Chat
                  _buildNavItem(
                    index: 2,
                    icon: Icons.chat_bubble_outline_rounded,
                    activeIcon: Icons.chat_bubble_rounded,
                    label: 'Chat',
                  ),
                  // Profile
                  _buildNavItem(
                    index: 3,
                    icon: Icons.person_outline_rounded,
                    activeIcon: Icons.person_rounded,
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    return Obx(() {
      final isSelected = controller.currentIndex.value == index;
      return GestureDetector(
        onTap: () => controller.changePage(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.kblue.withOpacity(0.1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                size: 26,
                color: isSelected ? AppColor.kblue : AppColor.greyLight,
              ),
            ),
          ],
        ),
      );
    });
  }
}
