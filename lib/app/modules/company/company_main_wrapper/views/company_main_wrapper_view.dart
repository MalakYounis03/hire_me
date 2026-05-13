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
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            ApplicationListView(),
            CompanyChatView(),
            CompanyDashboardView(),
            CompanyDashboardView(),
            CompanyPostJobView(showBackButton: false),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => _CompanyBottomNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}

class _CompanyBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int index) onTap;

  const _CompanyBottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      padding: const EdgeInsets.only(left: 26, right: 26, top: 10, bottom: 14),
      decoration: BoxDecoration(
        color: AppColor.kwhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.kblack.withValues(alpha: 0.06),
            blurRadius: 18,
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
              icon: Icons.insert_chart_outlined_rounded,
              activeIcon: Icons.insert_chart_rounded,
              isCenterActiveStyle: true,
            ),
            _navItem(
              index: 4,
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
    bool isCenterActiveStyle = false,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 54,
        height: 58,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSelected ? 58 : 44,
            height: isSelected ? 58 : 44,
            decoration: BoxDecoration(
              color: isSelected ? AppColor.kblue : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColor.kwhite : AppColor.kblue,
              size: isSelected ? 30 : 28,
            ),
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../../core/utils/app_color.dart';
// import '../../application_list/views/application_list_view.dart';
// import '../../company_chat/views/company_chat_view.dart';
// import '../../company_profile/views/company_profile_view.dart';
// import '../../dashboard/views/company_dashboard_view.dart';
// import '../../post_job/views/company_post_job_view.dart';
// import '../controllers/company_main_wrapper_controller.dart';

// class CompanyMainWrapperView extends GetView<CompanyMainWrapperController> {
//   const CompanyMainWrapperView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(
//         () => IndexedStack(
//           index: controller.currentIndex.value,
//           children: const [
//             CompanyDashboardView(),
//             ApplicationListView(),
//             CompanyPostJobView(showBackButton: false),
//             CompanyChatView(),
//             CompanyProfileView(),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: controller.onPostJobPressed,
//         backgroundColor: AppColor.kblue,
//         shape: const CircleBorder(),
//         elevation: 4,
//         child: Icon(Icons.add_rounded, color: AppColor.kwhite, size: 30),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: AppColor.kwhite,
//           boxShadow: [
//             BoxShadow(
//               color: AppColor.kblack.withValues(alpha: 0.04),
//               blurRadius: 20,
//               offset: const Offset(0, -5),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: BottomAppBar(
//               color: Colors.transparent,
//               elevation: 0,
//               notchMargin: 8,
//               shape: const CircularNotchedRectangle(),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildNavItem(
//                     index: 0,
//                     icon: Icons.home_outlined,
//                     activeIcon: Icons.home_rounded,
//                   ),
//                   _buildNavItem(
//                     index: 1,
//                     icon: Icons.description_outlined,
//                     activeIcon: Icons.description_rounded,
//                   ),
//                   const SizedBox(width: 48),
//                   _buildNavItem(
//                     index: 3,
//                     icon: Icons.chat_bubble_outline_rounded,
//                     activeIcon: Icons.chat_bubble_rounded,
//                   ),
//                   _buildNavItem(
//                     index: 4,
//                     icon: Icons.person_outline_rounded,
//                     activeIcon: Icons.person_rounded,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem({
//     required int index,
//     required IconData icon,
//     required IconData activeIcon,
//   }) {
//     return Obx(() {
//       final isSelected = controller.currentIndex.value == index;

//       return GestureDetector(
//         onTap: () => controller.changePage(index),
//         behavior: HitTestBehavior.opaque,
//         child: SizedBox(
//           width: 52,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? AppColor.kblue.withValues(alpha: 0.1)
//                       : Colors.transparent,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   isSelected ? activeIcon : icon,
//                   size: 26,
//                   color: isSelected ? AppColor.kblue : AppColor.greyLight,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
