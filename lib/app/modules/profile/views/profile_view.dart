import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/core/models/user_model.dart';
import 'package:hire_me/core/utils/app_color.dart';
import 'package:hire_me/core/utils/app_string.dart';
import 'package:hire_me/core/utils/app_text_style.dart';
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
              _buildEducationCard(),
              const SizedBox(height: 10),
              _buildExperienceCard(),
              const SizedBox(height: 10),
              _buildSkillsCard(),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      color: AppColor.kwhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(height: 100, color: const Color(0xFFB0BEC5)),
              Positioned(
                bottom: -40,
                left: 16,
                child: Obx(
                  () => Stack(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white,
                        child: controller.isUploadingImage.value
                            ? CircularProgressIndicator(color: AppColor.kblue)
                            : CircleAvatar(
                                radius: 40,
                                backgroundColor: const Color(0xFFE8EDF9),
                                backgroundImage: controller.userImage.isNotEmpty
                                    ? NetworkImage(controller.userImage)
                                    : null,
                                child: controller.userImage.isEmpty
                                    ? Icon(
                                        Icons.person_rounded,
                                        size: 40,
                                        color: AppColor.kblue,
                                      )
                                    : null,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: controller.pickAndUploadImage, // ← صلّحنا هاد
                          child: Container(
                            width: 26,
                            height: 26,
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 52),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              // ← Column بدل Row
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الاسم
                Obx(
                  () => Text(
                    controller.userName.isEmpty
                        ? 'Your Name'
                        : controller.userName.toUpperCase(),
                    style: CustomTextstyle.Intermeduim,
                  ),
                ),

                const SizedBox(height: 4),

                Obx(
                  () => controller.userTitle.isEmpty
                      ? const SizedBox.shrink()
                      : Text(
                          controller.userTitle,
                          style: CustomTextstyle.Interregular400,
                        ),
                ),

                const SizedBox(height: 2),

                Obx(
                  () => controller.userUniversity.isEmpty
                      ? const SizedBox.shrink()
                      : Text(
                          controller.userUniversity,
                          style: CustomTextstyle.Interregular400,
                        ),
                ),

                const SizedBox(height: 2),

                Obx(
                  () => controller.userLocation.isEmpty
                      ? const SizedBox.shrink()
                      : Text(
                          controller.userLocation,
                          style: CustomTextstyle.Roboto300,
                        ),
                ),

                const SizedBox(height: 14),

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
        color: const Color(0xffE9E5DF),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About', style: CustomTextstyle.Intersemiboldblackk),
                const SizedBox(height: 8),
                Obx(
                  () => controller.userAbout.isEmpty
                      ? const Text(
                          'Add about yourself...',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF8A8A9A),
                          ),
                        )
                      : Text(
                          controller.userAbout,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1A1A2E),
                          ),
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

  Widget _buildEducationCard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Education', style: CustomTextstyle.Intersemiboldblackk),
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
          const SizedBox(height: 12),
          Obx(() {
            if (controller.education.isEmpty) {
              return _addButton(
                'Add Education',
                controller.showAddEducationDialog,
              );
            }
            return Column(
              children: [
                ...controller.education.map((e) => _educationItem(e)),
                const SizedBox(height: 8),
                _addButton('Add Education', controller.showAddEducationDialog),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _educationItem(EducationModel e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EDF9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.school_outlined, color: AppColor.kblue, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.school, style: CustomTextstyle.SegoeUI),
                Text(
                  '${e.degree} · ${e.field}',
                  style: CustomTextstyle.SegoeUI,
                ),
                Text(
                  '${e.startYear} - ${e.endYear}',
                  style: CustomTextstyle.SegoeUI,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Experience', style: CustomTextstyle.Intersemiboldblackk),
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
          const SizedBox(height: 12),
          Obx(() {
            if (controller.experience.isEmpty) {
              return _addButton(
                'Add experience',
                controller.showAddExperienceDialog,
              );
            }
            return Column(
              children: [
                ...controller.experience.map((e) => _experienceItem(e)),
                const SizedBox(height: 8),
                _addButton(
                  'Add experience',
                  controller.showAddExperienceDialog,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _experienceItem(ExperienceModel e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EDF9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.work_outline_rounded,
              color: AppColor.kblue,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.position, style: CustomTextstyle.SegoeUI),
                Text(e.company, style: CustomTextstyle.SegoeUI),
                Text(
                  '${e.startDate} - ${e.endDate}',
                  style: CustomTextstyle.SegoeUI,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsCard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Skills', style: CustomTextstyle.Intersemiboldblackk),
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
          const SizedBox(height: 12),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.skills.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.skills
                        .asMap()
                        .entries
                        .map((e) => _skillChip(e.value, e.key))
                        .toList(),
                  ),
                if (controller.skills.isNotEmpty) const SizedBox(height: 10),
                _addButton('Add Skills', controller.showAddSkillDialog),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _skillChip(String skill, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EDF9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            skill,
            style: TextStyle(
              fontSize: 13,
              color: AppColor.kblue,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => controller.removeSkill(index),
            child: Icon(Icons.close, size: 14, color: AppColor.kblue),
          ),
        ],
      ),
    );
  }

  Widget _addButton(String label, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: Color(0xFF8A8A9A)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      icon: const Icon(Icons.add, size: 18, color: Color(0xFF1A1A2E)),
      label: Text(
        label,
        style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13),
      ),
    );
  }
}
