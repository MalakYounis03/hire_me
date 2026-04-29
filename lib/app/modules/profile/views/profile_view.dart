import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/core/utils/app_color.dart';
import 'package:hire_me/core/utils/app_string.dart';
import 'package:hire_me/core/utils/app_text_style.dart';
import 'package:hire_me/core/widgets/app_bottom_nav_bar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kwhite,
      appBar: AppBar(
        backgroundColor: AppColor.kblue,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back, color: AppColor.kwhite),
        ),
        title: Text(
          AppString.profile,
          style: CustomTextstyle.Intersemiboldwhite,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.notifications_outlined,
              color: AppColor.kwhite,
              size: 26,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.kblue),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileCard(),
              const SizedBox(height: 10),
              _buildOpenToWorkCard(),
              const SizedBox(height: 10),
              _buildAboutCard(),
              const SizedBox(height: 10),
              _buildSectionCard(
                title: 'Experience',
                buttonLabel: 'Add experience',
                onAdd: () {},
              ),
              const SizedBox(height: 10),
              _buildSectionCard(
                title: 'Education',
                buttonLabel: 'Add Education',
                onAdd: () {},
              ),
              const SizedBox(height: 10),
              _buildSectionCard(
                title: 'Skills',
                buttonLabel: 'Add Skills',
                onAdd: () {},
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      color: AppColor.kwhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover + Avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Cover
              Container(height: 100, color: const Color(0xFFB0BEC5)),

              // Avatar
              Positioned(
                bottom: -40,
                left: 16,
                child: Stack(
                  children: [
                    Obx(
                      () => CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color(0xFFE8EDF9),
                          backgroundImage: controller.userImage.value.isNotEmpty
                              ? NetworkImage(controller.userImage.value)
                              : null,
                          child: controller.userImage.value.isEmpty
                              ? Icon(
                                  Icons.person_rounded,
                                  size: 40,
                                  color: AppColor.kblue,
                                )
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColor.kblue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 48),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Obx(
                      () => Text(
                        controller.userName.value.isEmpty
                            ? 'Your Name'
                            : controller.userName.value.toUpperCase(),
                        style: CustomTextstyle.Intermeduim,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('· 3rd', style: CustomTextstyle.Roboto),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'UX/UI Design _flutter',
                  style: CustomTextstyle.Interregular400,
                ),
                const SizedBox(height: 2),
                Text(
                  'AL_Azhar University (AUG)',
                  style: CustomTextstyle.Interregular400,
                ),
                const SizedBox(height: 2),
                Obx(
                  () => Text(
                    controller.userLocation.value.isEmpty
                        ? 'Palestine_Gaza'
                        : controller.userLocation.value,
                    style: CustomTextstyle.Roboto300,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '2,900 followers • 1,300 connections',
                  style: CustomTextstyle.Interregular700,
                ),
                const SizedBox(height: 14),

                // Buttons
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.light_themeBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Open to',
                        style: CustomTextstyle.Interregular500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide(color: AppColor.light_themeGrey),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        'Add section',
                        style: CustomTextstyle.Interregular500grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide(color: AppColor.light_themeGrey),
                        minimumSize: const Size(36, 36),
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(
                        Icons.more_horiz,
                        color: AppColor.light_themeGrey,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenToWorkCard() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffE9E5DF),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(18),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Open to work',
                  style: CustomTextstyle.Interregularblackbold,
                ),
                const SizedBox(height: 4),
                Text('UX/UI Design', style: CustomTextstyle.Interregular18),

                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'See all details',
                    style: CustomTextstyle.Interregular700,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.edit_outlined,
              color: AppColor.light_themeGrey,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'AUG_Softwer Engineering || UX/UI & Flutter',
                  style: TextStyle(fontSize: 13, color: Color(0xFF1A1A2E)),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.edit_outlined,
              color: Color(0xFF8A8A9A),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String buttonLabel,
    required VoidCallback onAdd,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF8A8A9A),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onAdd,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: const BorderSide(color: Color(0xFF8A8A9A)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            icon: const Icon(Icons.add, size: 18, color: Color(0xFF1A1A2E)),
            label: Text(
              buttonLabel,
              style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
