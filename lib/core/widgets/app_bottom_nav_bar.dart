import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_pages.dart';
import 'package:hire_me/core/utils/app_color.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            isActive: currentIndex == 0,
            onTap: () => _navigate(0),
          ),
          _NavItem(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Chat',
            isActive: currentIndex == 1,
            onTap: () => _navigate(1),
          ),
          _NavItemCenter(
            isActive: currentIndex == 2,
            onTap: () => _navigate(2),
          ),
          _NavItem(
            icon: Icons.work_outline_rounded,
            label: 'Jobs',
            isActive: currentIndex == 3,
            onTap: () => _navigate(3),
          ),
          _NavItem(
            icon: Icons.bookmark_add_outlined,
            label: 'Saved',
            isActive: currentIndex == 4,
            onTap: () => _navigate(4),
          ),
        ],
      ),
    );
  }

  void _navigate(int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        Get.offAllNamed(Routes.PROFILE);
        break;
      case 2:
        Get.offAllNamed(Routes.JOB_SEEKER_DASHBOARD);
        break;
      case 3:
        Get.offAllNamed(Routes.JOB_SEEKER_MY_APPLICATIONS);
        break;
    }
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? AppColor.kblue : const Color(0xFFB0B0C0),
            size: 26,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? AppColor.kblue : const Color(0xFFB0B0C0),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItemCenter extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _NavItemCenter({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColor.kblue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColor.kblue.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(Icons.home_rounded, color: AppColor.kwhite, size: 28),
      ),
    );
  }
}
