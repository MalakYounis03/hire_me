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
      backgroundColor: const Color(0xFFF5F7FF),
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
              _buildAboutCard(),
              const SizedBox(height: 10),
              _buildExperienceCard(),
              const SizedBox(height: 10),
              _buildEducationCard(),
              const SizedBox(height: 10),
              _buildSkillsCard(),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  // ── Profile Card ──────────────────────────────────────
  Widget _buildProfileCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
<<<<<<< HEAD
              // ── Cover Photo ──────────────────────────
              // ── Cover Photo ──────────────────────────
=======
>>>>>>> main
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Obx(() {
<<<<<<< HEAD
                  return Container(
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB0BEC5),
                      image: controller.coverImage.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(controller.coverImage),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: controller.pickAndUploadCover, // ← هون بس
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 18,
                              color: AppColor.kblue,
                            ),
                          ),
                        ),
=======
                  final hasCover = controller.coverImage.isNotEmpty;
                  return GestureDetector(
                    onTap: controller.pickAndUploadCover,
                    child: Container(
                      height: 110,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB0BEC5),
                        image: hasCover
                            ? DecorationImage(
                                image: NetworkImage(controller.coverImage),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: Obx(
                        () => controller.isUploadingCover.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.8),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 18,
                                      color: AppColor.kblue,
                                    ),
                                  ),
                                ),
                              ),
>>>>>>> main
                      ),
                    ),
                  );
                }),
              ),

<<<<<<< HEAD
              // ── Profile Photo ─────────────────────────
=======
>>>>>>> main
              Positioned(
                bottom: -36,
                left: 16,
                child: Obx(
                  () => GestureDetector(
                    onTap: controller.pickAndUploadImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: Colors.white,
                          child: controller.isUploadingImage.value
                              ? CircularProgressIndicator(color: AppColor.kblue)
                              : CircleAvatar(
                                  radius: 40,
                                  backgroundColor: const Color(0xFFE8EDF9),
                                  backgroundImage:
                                      controller.userImage.isNotEmpty
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 48),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
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

                // Title
                Obx(
                  () => controller.userTitle.isEmpty
                      ? const SizedBox.shrink()
                      : Text(
                          controller.userTitle,
                          style: CustomTextstyle.Interregular400,
                        ),
                ),

                const SizedBox(height: 2),

                // University
                Obx(
                  () => controller.userUniversity.isEmpty
                      ? const SizedBox.shrink()
                      : Text(
                          controller.userUniversity,
                          style: CustomTextstyle.Interregular400,
                        ),
                ),

                const SizedBox(height: 2),

                // Location — مرة وحدة بس
                Obx(
                  () => controller.userLocation.isEmpty
                      ? const SizedBox.shrink()
                      : Text(
                          controller.userLocation,
                          style: CustomTextstyle.Roboto300,
                        ),
                ),

                const SizedBox(height: 14),

                // الأزرار
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.kblue,
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

<<<<<<< HEAD
  // ── About Card ────────────────────────────────────────
=======
>>>>>>> main
  Widget _buildAboutCard() {
    return _sectionCard(
      icon: Icons.person_outline_rounded,
      title: 'About',
      child: Obx(
        () => controller.userAbout.isEmpty
            ? const Text(
                'Add about yourself...',
                style: TextStyle(fontSize: 13, color: Color(0xFF8A8A9A)),
              )
            : Text(
                controller.userAbout,
                style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A2E)),
              ),
      ),
    );
  }

<<<<<<< HEAD
  // ── Experience Card ───────────────────────────────────
=======
>>>>>>> main
  Widget _buildExperienceCard() {
    return _sectionCard(
      icon: Icons.calendar_today_outlined,
      title: 'Experience',
      child: Obx(
        () => controller.experience.isEmpty
            ? _addButton('Add experience', controller.showAddExperienceDialog)
            : Column(
                children: [
                  ...controller.experience.map((e) => _experienceItem(e)),
                  const SizedBox(height: 8),
                  _addButton(
                    'Add experience',
                    controller.showAddExperienceDialog,
                  ),
                ],
              ),
      ),
    );
  }

<<<<<<< HEAD
  // ── Education Card ────────────────────────────────────
=======
>>>>>>> main
  Widget _buildEducationCard() {
    return _sectionCard(
      icon: Icons.school_outlined,
      title: 'Education',
      child: Obx(
        () => controller.education.isEmpty
            ? _addButton('Add Education', controller.showAddEducationDialog)
            : Column(
                children: [
                  ...controller.education.map((e) => _educationItem(e)),
                  const SizedBox(height: 8),
                  _addButton(
                    'Add Education',
                    controller.showAddEducationDialog,
                  ),
                ],
              ),
      ),
    );
  }

<<<<<<< HEAD
  // ── Skills Card ───────────────────────────────────────
=======
>>>>>>> main
  Widget _buildSkillsCard() {
    return _sectionCard(
      icon: Icons.description_outlined,
      title: 'Skills',
      child: Obx(
        () => Column(
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
        ),
      ),
    );
  }

<<<<<<< HEAD
  // ── Shared Section Card ───────────────────────────────
=======
>>>>>>> main
  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColor.kblue, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
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
          child,
        ],
      ),
    );
  }

  // ── Education Item ────────────────────────────────────
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
                Text(
                  e.school,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                Text(
                  '${e.degree} · ${e.field}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8A8A9A),
                  ),
                ),
                Text(
                  '${e.startYear} - ${e.endYear}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8A8A9A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  // ── Experience Item ───────────────────────────────────
=======
>>>>>>> main
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
                Text(
                  e.position,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                Text(
                  e.company,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8A8A9A),
                  ),
                ),
                Text(
                  '${e.startDate} - ${e.endDate}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8A8A9A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  // ── Skill Chip ────────────────────────────────────────
=======
>>>>>>> main
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

  // ── Logout Button ─────────────────────────────────────

  // ── Add Button ────────────────────────────────────────
  Widget _addButton(String label, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: AppColor.kblue),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      icon: Icon(Icons.add, size: 18, color: AppColor.kblue),
      label: Text(label, style: TextStyle(color: AppColor.kblue, fontSize: 13)),
    );
  }
}
