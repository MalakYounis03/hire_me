import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_pages.dart';
import 'package:hire_me/app/modules/profile/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  // ── State ─────────────────────────────────────────────
  final userModel = Rxn<UserModel>();
  final isLoading = false.obs;
  final isUploadingImage = false.obs;
  final isUploadingCover = false.obs;
  final openToOptions = <String>[].obs;

  // ── Firebase + Supabase ───────────────────────────────
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _supabase = Supabase.instance.client;
  final _picker = ImagePicker();

  // ── Getters ───────────────────────────────────────────
  String get userName => userModel.value?.name ?? '';
  String get userTitle => userModel.value?.title ?? '';
  String get userUniversity => userModel.value?.university ?? '';
  String get userLocation => userModel.value?.location ?? '';
  String get userAbout => userModel.value?.about ?? '';
  String get userImage => userModel.value?.profileImage ?? '';
  String get coverImage => userModel.value?.coverImage ?? '';
  List<EducationModel> get education => userModel.value?.education ?? [];
  List<ExperienceModel> get experience => userModel.value?.experience ?? [];
  List<String> get skills => userModel.value?.skills ?? [];
  bool get isOpenToWork => openToOptions.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  // ── Load Profile ──────────────────────────────────────
  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final uid = _auth.currentUser!.uid;
      final doc = await _firestore.collection('jobSeekers').doc(uid).get();

      if (doc.exists) {
        userModel.value = UserModel.fromMap(doc.data()!);

        // fallback للاسم
        if (userModel.value?.name.isEmpty ?? true) {
          final userDoc = await _firestore.collection('users').doc(uid).get();
          final name = userDoc.data()?['name'] ?? '';
          if (name.isNotEmpty) {
            await _updateField('name', name);
            userModel.value = userModel.value?.copyWith(name: name);
          }
        }

        // حمّل openToOptions
        final saved = List<String>.from(doc.data()?['openToOptions'] ?? []);
        openToOptions.assignAll(saved);
      } else {
        final userDoc = await _firestore.collection('users').doc(uid).get();
        final name = userDoc.data()?['name'] ?? '';
        final newUser = UserModel(
          uid: uid,
          email: _auth.currentUser?.email ?? '',
          role: 'jobseeker',
          name: name,
        );
        await _firestore.collection('jobSeekers').doc(uid).set(newUser.toMap());
        userModel.value = newUser;
      }
    } catch (e) {
      _showError('Failed to load profile');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Open To Work ──────────────────────────────────────
  void showOpenToBottomSheet() {
    final allOptions = ['Open to Work', 'Freelance', 'Internship'];

    // نسخة مؤقتة observable — بدون StatefulBuilder
    final tempSelected = <String>[...openToOptions].obs;

    Get.bottomSheet(
      // Obx مباشرة بدون StatefulBuilder
      Obx(
        () => Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Open to',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Let recruiters know what opportunities you're looking for",
                style: TextStyle(fontSize: 13, color: Color(0xFF8A8A9A)),
              ),
              const SizedBox(height: 20),

              // ── Options ──
              ...allOptions.map((option) {
                final isSelected = tempSelected.contains(option);
                return GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      tempSelected.remove(option);
                    } else {
                      tempSelected.add(option);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE8EDF9)
                          : const Color(0xFFF5F7FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1A3794)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(
                                    0xFF1A3794,
                                  ).withValues(alpha: 0.12)
                                : const Color(0xFFE8EDF9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _optionIcon(option),
                            color: isSelected
                                ? const Color(0xFF1A3794)
                                : const Color(0xFF8A8A9A),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          option,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? const Color(0xFF1A3794)
                                : const Color(0xFF1A1A2E),
                          ),
                        ),
                        const Spacer(),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: isSelected
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF1A3794),
                                  size: 22,
                                  key: ValueKey('check'),
                                )
                              : const Icon(
                                  Icons.circle_outlined,
                                  color: Color(0xFFCCCCCC),
                                  size: 22,
                                  key: ValueKey('empty'),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // ── Save ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    await _saveOpenTo(List<String>.from(tempSelected));
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A3794),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _saveOpenTo(List<String> selected) async {
    openToOptions.assignAll(selected);
    await _updateField('openToOptions', selected);
  }

  IconData _optionIcon(String option) {
    switch (option) {
      case 'Open to Work':
        return Icons.work_outline_rounded;
      case 'Freelance':
        return Icons.laptop_outlined;
      case 'Internship':
        return Icons.school_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  // ── Upload Profile Image ──────────────────────────────
  Future<void> pickAndUploadImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null) return;

    isUploadingImage.value = true;
    try {
      final uid = _auth.currentUser!.uid;
      final fileName = 'profile_$uid.jpg';
      await _supabase.storage
          .from('profile-images')
          .upload(
            fileName,
            File(picked.path),
            fileOptions: const FileOptions(upsert: true),
          );
      final imageUrl = _supabase.storage
          .from('profile-images')
          .getPublicUrl(fileName);
      await _updateField('profileImage', imageUrl);
      userModel.value = userModel.value?.copyWith(profileImage: imageUrl);
      _showSuccess('Profile photo updated!');
    } catch (e) {
      _showError('Failed to upload photo: $e');
    } finally {
      isUploadingImage.value = false;
    }
  }

  // ── Upload Cover Image ────────────────────────────────
  Future<void> pickAndUploadCover() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null) return;

    isUploadingCover.value = true;
    try {
      final uid = _auth.currentUser!.uid;
      final fileName = 'cover_$uid.jpg';
      await _supabase.storage
          .from('profile-images')
          .upload(
            fileName,
            File(picked.path),
            fileOptions: const FileOptions(upsert: true),
          );
      final coverUrl = _supabase.storage
          .from('profile-images')
          .getPublicUrl(fileName);
      await _updateField('coverImage', coverUrl);
      userModel.value = userModel.value?.copyWith(coverImage: coverUrl);
      _showSuccess('Cover photo updated!');
    } catch (e) {
      _showError('Failed to upload cover: $e');
    } finally {
      isUploadingCover.value = false;
    }
  }

  // ── About ─────────────────────────────────────────────
  void showEditAboutDialog() {
    final ctrl = TextEditingController(text: userAbout);
    _showEditDialog(
      title: 'Edit About',
      fields: [_dialogField(ctrl, 'About yourself...', maxLines: 4)],
      onSave: () async {
        await _updateField('about', ctrl.text.trim());
        userModel.value = userModel.value?.copyWith(about: ctrl.text.trim());
      },
    );
  }

  // ── Education ─────────────────────────────────────────
  void showAddEducationDialog() => _openEducationDialog();
  void showEditEducationDialog(int index) =>
      _openEducationDialog(index: index, existing: education[index]);

  Future<void> deleteEducation(int index) async {
    final updated = [...education]..removeAt(index);
    await _updateField('education', updated.map((e) => e.toMap()).toList());
    userModel.value = userModel.value?.copyWith(education: updated);
  }

  void _openEducationDialog({int? index, EducationModel? existing}) {
    final schoolCtrl = TextEditingController(text: existing?.school ?? '');
    final degreeCtrl = TextEditingController(text: existing?.degree ?? '');
    final fieldCtrl = TextEditingController(text: existing?.field ?? '');
    final startCtrl = TextEditingController(text: existing?.startYear ?? '');
    final endCtrl = TextEditingController(text: existing?.endYear ?? '');

    _showEditDialog(
      title: index == null ? 'Add Education' : 'Edit Education',
      fields: [
        _dialogField(schoolCtrl, 'School / University'),
        _dialogField(degreeCtrl, 'Degree'),
        _dialogField(fieldCtrl, 'Field of Study'),
        _dialogField(startCtrl, 'Start Year'),
        _dialogField(endCtrl, 'End Year'),
      ],
      onSave: () async {
        if (schoolCtrl.text.isEmpty) return;
        final edu = EducationModel(
          school: schoolCtrl.text,
          degree: degreeCtrl.text,
          field: fieldCtrl.text,
          startYear: startCtrl.text,
          endYear: endCtrl.text,
        );
        final updated = [...education];
        index == null ? updated.add(edu) : updated[index] = edu;
        await _updateField('education', updated.map((e) => e.toMap()).toList());
        userModel.value = userModel.value?.copyWith(education: updated);
      },
    );
  }

  // ── Experience ────────────────────────────────────────
  void showAddExperienceDialog() => _openExperienceDialog();
  void showEditExperienceDialog(int index) =>
      _openExperienceDialog(index: index, existing: experience[index]);

  Future<void> deleteExperience(int index) async {
    final updated = [...experience]..removeAt(index);
    await _updateField('experience', updated.map((e) => e.toMap()).toList());
    userModel.value = userModel.value?.copyWith(experience: updated);
  }

  void _openExperienceDialog({int? index, ExperienceModel? existing}) {
    final companyCtrl = TextEditingController(text: existing?.company ?? '');
    final positionCtrl = TextEditingController(text: existing?.position ?? '');
    final startCtrl = TextEditingController(text: existing?.startDate ?? '');
    final endCtrl = TextEditingController(text: existing?.endDate ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');

    _showEditDialog(
      title: index == null ? 'Add Experience' : 'Edit Experience',
      fields: [
        _dialogField(companyCtrl, 'Company'),
        _dialogField(positionCtrl, 'Position'),
        _dialogField(startCtrl, 'Start Date'),
        _dialogField(endCtrl, 'End Date'),
        _dialogField(descCtrl, 'Description', maxLines: 3),
      ],
      onSave: () async {
        if (companyCtrl.text.isEmpty) return;
        final exp = ExperienceModel(
          company: companyCtrl.text,
          position: positionCtrl.text,
          startDate: startCtrl.text,
          endDate: endCtrl.text,
          description: descCtrl.text,
        );
        final updated = [...experience];
        index == null ? updated.add(exp) : updated[index] = exp;
        await _updateField(
          'experience',
          updated.map((e) => e.toMap()).toList(),
        );
        userModel.value = userModel.value?.copyWith(experience: updated);
      },
    );
  }

  // ── Skills ────────────────────────────────────────────
  void showAddSkillDialog() {
    final skillCtrl = TextEditingController();
    _showEditDialog(
      title: 'Add Skill',
      fields: [_dialogField(skillCtrl, 'Skill name')],
      onSave: () async {
        if (skillCtrl.text.trim().isEmpty) return;
        final updated = [...skills, skillCtrl.text.trim()];
        await _updateField('skills', updated);
        userModel.value = userModel.value?.copyWith(skills: updated);
      },
    );
  }

  Future<void> removeSkill(int index) async {
    final updated = [...skills]..removeAt(index);
    await _updateField('skills', updated);
    userModel.value = userModel.value?.copyWith(skills: updated);
  }

  // ── Logout ────────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.SPLASH);
  }

  // ── Shared Dialog Helper ──────────────────────────────
  void _showEditDialog({
    required String title,
    required List<Widget> fields,
    required Future<void> Function() onSave,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: fields),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await onSave();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A3794),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _updateField(String field, dynamic value) async {
    final uid = _auth.currentUser!.uid;
    await _firestore.collection('jobSeekers').doc(uid).update({field: value});
  }

  Widget _dialogField(
    TextEditingController ctrl,
    String hint, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  void _showError(String msg) => Get.snackbar(
    'Error',
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color(0xFFEF4444),
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
  );

  void _showSuccess(String msg) => Get.snackbar(
    'Success',
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color(0xFF22C55E),
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
  );
}
