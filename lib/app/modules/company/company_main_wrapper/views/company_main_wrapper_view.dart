import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/app_color.dart';
import '../../application_list/views/application_list_view.dart';
import '../../company_chat/views/company_chat_view.dart';
import '../../dashboard/views/company_dashboard_view.dart';
import '../../post_job/views/company_post_job_view.dart';
import '../controllers/company_main_wrapper_controller.dart';

class CompanyMainWrapperView extends GetView<CompanyMainWrapperController> {
  const CompanyMainWrapperView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: Obx(() => _buildCurrentPage(controller.currentIndex.value)),
      bottomNavigationBar: Obx(
        () => _CompanyBottomNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
        ),
      ),
    );
  }

  Widget _buildCurrentPage(int index) {
    switch (index) {
      case 0:
        return const ApplicationListView();

      case 1:
        return const CompanyChatView();

      case 2:
        return const CompanyDashboardView();

      case 3:
        return const CompanyPostJobView();

      default:
        return const CompanyDashboardView();
    }
  }
}

class _CompanyBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int index) onTap;

  const _CompanyBottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      padding: const EdgeInsets.only(left: 34, right: 34, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: AppColor.kwhite,
        boxShadow: [
          BoxShadow(
            color: AppColor.kblack.withValues(alpha: 0.05),
            blurRadius: 22,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navItem(
              index: 0,
              icon: Icons.account_balance_outlined,
              activeIcon: Icons.account_balance_rounded,
            ),
            _navItem(
              index: 1,
              icon: Icons.chat_bubble_outline_rounded,
              activeIcon: Icons.chat_bubble_rounded,
            ),
            _navItem(
              index: 2,
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
            ),
            _navItem(
              index: 3,
              icon: Icons.business_center_outlined,
              activeIcon: Icons.business_center_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 58,
        height: 58,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            width: isSelected ? 56 : 44,
            height: isSelected ? 56 : 44,
            decoration: BoxDecoration(
              color: isSelected ? AppColor.kblue : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColor.kwhite : AppColor.kblue,
              size: isSelected ? 30 : 27,
            ),
          ),
        ),
      ),
    );
  }
}
