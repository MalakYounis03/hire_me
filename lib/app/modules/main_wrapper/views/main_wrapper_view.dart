import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hire_me/app/core/utils/app_color.dart';
import 'package:hire_me/app/modules/job_seeker/chat/views/chat_view.dart';
import 'package:hire_me/app/modules/job_seeker/dashboard/views/job_seeker_dashboard_view.dart';
import 'package:hire_me/app/modules/job_seeker/my_applications/views/job_seeker_my_applications_view.dart';
import 'package:hire_me/app/modules/job_seeker/saved_jobs/views/job_seeker_saved_jobs_view.dart';
import 'package:hire_me/app/modules/profile/views/profile_view.dart';

import '../controllers/main_wrapper_controller.dart';

class MainWrapperView extends GetView<MainWrapperController> {
  const MainWrapperView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            ProfileView(),
            ChatView(),
            JobSeekerDashboardView(),
            JobSeekerMyApplicationsView(),
            JobSeekerSavedJobsView(),
          ],
        ),
      ),
      bottomNavigationBar: const _MainBottomNavBar(),
    );
  }
}

class _MainBottomNavBar extends GetView<MainWrapperController> {
  const _MainBottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: AppColor.kwhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _navIcon(
                index: 0,
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
              ),
              _navIcon(
                index: 1,
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble_rounded,
              ),
              _homeIcon(),
              _navIcon(
                index: 3,
                icon: Icons.work_outline_rounded,
                activeIcon: Icons.work_rounded,
              ),
              _navIcon(
                index: 4,
                icon: Icons.bookmark_border_rounded,
                activeIcon: Icons.bookmark_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homeIcon() {
    final isSelected = controller.currentIndex.value == 2;

    return GestureDetector(
      onTap: () => controller.changePage(2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isSelected ? AppColor.kblue : AppColor.kwhite,
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.kblue, width: 1.2),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColor.kblue.withOpacity(0.22),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Icon(
          isSelected ? Icons.home_rounded : Icons.home_outlined,
          color: isSelected ? AppColor.kwhite : AppColor.kblue,
          size: 25,
        ),
      ),
    );
  }

  Widget _navIcon({
    required int index,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final isSelected = controller.currentIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changePage(index),
      child: SizedBox(
        width: 42,
        height: 52,
        child: Center(
          child: Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? AppColor.kblue : AppColor.greyLight,
            size: 25,
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:hire_me/app/core/utils/app_color.dart';
// import 'package:hire_me/app/modules/job_seeker/chat/views/chat_view.dart';
// import 'package:hire_me/app/modules/job_seeker/dashboard/views/job_seeker_dashboard_view.dart';
// import 'package:hire_me/app/modules/job_seeker/my_applications/views/job_seeker_my_applications_view.dart';
// import 'package:hire_me/app/modules/job_seeker/saved_jobs/views/job_seeker_saved_jobs_view.dart';
// import 'package:hire_me/app/modules/profile/views/profile_view.dart';

// import '../controllers/main_wrapper_controller.dart';

// class MainWrapperView extends GetView<MainWrapperController> {
//   const MainWrapperView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF5F7FA),
//       body: Obx(
//         () => IndexedStack(
//           index: controller.currentIndex.value,
//           children: const [
//             ProfileView(),
//             ChatView(),
//             JobSeekerDashboardView(),
//             JobSeekerMyApplicationsView(),
//             JobSeekerSavedJobsView(),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const _MainBottomNavigationBar(),
//     );
//   }
// }

// class _MainBottomNavigationBar extends GetView<MainWrapperController> {
//   const _MainBottomNavigationBar();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 76,
//       padding: const EdgeInsets.symmetric(horizontal: 26),
//       decoration: BoxDecoration(
//         color: AppColor.kwhite,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 18,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         top: false,
//         child: Obx(
//           () => Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _navIcon(
//                 index: 0,
//                 icon: Icons.person_outline_rounded,
//                 activeIcon: Icons.person_rounded,
//               ),
//               _navIcon(
//                 index: 1,
//                 icon: Icons.chat_bubble_outline_rounded,
//                 activeIcon: Icons.chat_bubble_rounded,
//               ),
//               _homeIcon(),
//               _navIcon(
//                 index: 3,
//                 icon: Icons.work_outline_rounded,
//                 activeIcon: Icons.work_rounded,
//               ),
//               _navIcon(
//                 index: 4,
//                 icon: Icons.bookmark_border_rounded,
//                 activeIcon: Icons.bookmark_rounded,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _homeIcon() {
//     final isSelected = controller.currentIndex.value == 2;

//     return GestureDetector(
//       onTap: () => controller.changePage(2),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         width: 52,
//         height: 52,
//         decoration: BoxDecoration(
//           color: isSelected ? AppColor.kblue : AppColor.kwhite,
//           shape: BoxShape.circle,
//           border: Border.all(color: AppColor.kblue, width: 1.2),
//           boxShadow: isSelected
//               ? [
//                   BoxShadow(
//                     color: AppColor.kblue.withOpacity(0.22),
//                     blurRadius: 14,
//                     offset: const Offset(0, 6),
//                   ),
//                 ]
//               : [],
//         ),
//         child: Icon(
//           isSelected ? Icons.home_rounded : Icons.home_outlined,
//           color: isSelected ? AppColor.kwhite : AppColor.kblue,
//           size: 26,
//         ),
//       ),
//     );
//   }

//   Widget _navIcon({
//     required int index,
//     required IconData icon,
//     required IconData activeIcon,
//   }) {
//     final isSelected = controller.currentIndex.value == index;

//     return GestureDetector(
//       onTap: () => controller.changePage(index),
//       child: SizedBox(
//         width: 42,
//         height: 52,
//         child: Center(
//           child: Icon(
//             isSelected ? activeIcon : icon,
//             color: isSelected ? AppColor.kblue : AppColor.greyLight,
//             size: 25,
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../core/utils/app_color.dart';
// import '../../job_seeker/chat/views/chat_view.dart';
// import '../../job_seeker/dashboard/views/job_seeker_dashboard_view.dart';
// import '../controllers/main_wrapper_controller.dart';
// import '../../profile/views/profile_view.dart';

// class MainWrapperView extends GetView<MainWrapperController> {
//   const MainWrapperView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // الـ IndexedStack يحافظ على حالة الصفحات (مثلاً مكان السكرول في الداشبورد)
//       body: Obx(
//         () => IndexedStack(
//           index: controller.currentIndex.value,
//           children: [
//             const JobSeekerDashboardView(),
//             const ChatView(),
//             const Center(child: Text("Portfolio Page")),
//             const ProfileView(),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Obx(
//         () => Container(
//           // إضافة ظل ناعم جداً لفصل الـ Bar عن المحتوى (مثل الفيجما)
//           decoration: BoxDecoration(
//             color: AppColor.kwhite,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 20,
//                 offset: const Offset(0, -5),
//               ),
//             ],
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               child: BottomNavigationBar(
//                 currentIndex: controller.currentIndex.value,
//                 onTap: controller.changePage,
//                 type: BottomNavigationBarType.fixed,
//                 backgroundColor:
//                     Colors.transparent, // شفاف لأننا نستخدم لون الـ Container
//                 elevation: 0,
//                 selectedItemColor: AppColor.kblue,
//                 unselectedItemColor: AppColor.greyLight,
//                 showSelectedLabels: false, // إخفاء النصوص تماماً
//                 showUnselectedLabels: false,
//                 items: [
//                   _buildNavItem(
//                     icon: Icons.home_outlined,
//                     activeIcon: Icons.home_rounded,
//                     label: "Home",
//                   ),
//                   _buildNavItem(
//                     icon: Icons.chat_bubble_outline_rounded,
//                     activeIcon: Icons.chat_bubble_rounded,
//                     label: "Chat",
//                   ),
//                   _buildNavItem(
//                     icon: Icons.work_outline_rounded,
//                     activeIcon: Icons.work_rounded,
//                     label: "Jobs",
//                   ),
//                   _buildNavItem(
//                     icon: Icons.person_outline_rounded,
//                     activeIcon: Icons.person_rounded,
//                     label: "Profile",
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // دالة مساعدة لبناء عناصر الـ Bar بدقة عالية
//   BottomNavigationBarItem _buildNavItem({
//     required IconData icon,
//     required IconData activeIcon,
//     required String label,
//   }) {
//     return BottomNavigationBarItem(
//       icon: Icon(icon, size: 26),
//       activeIcon: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: AppColor.kblue.withOpacity(
//             0.1,
//           ), // خلفية خفيفة عند الاختيار (اختياري)
//           shape: BoxShape.circle,
//         ),
//         child: Icon(activeIcon, size: 26),
//       ),
//       label: label,
//     );
//   }
// }
