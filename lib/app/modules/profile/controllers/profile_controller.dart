import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  // ── State ─────────────────────────────────────────────
  final userModel = Rxn<UserModel>();
  final isLoading = false.obs;
  final isUploadingImage = false.obs;
  final isUploadingCover = false.obs;

  // ── Firebase + Supabase ───────────────────────────────
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _supabase = Supabase.instance.client;
  final _picker = ImagePicker();

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

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final uid = _auth.currentUser!.uid;
      final doc = await _firestore.collection('jobSeekers').doc(uid).get();

      if (doc.exists) {
        userModel.value = UserModel.fromMap(doc.data()!);
      } else {
        final userDoc = await _firestore.collection('users').doc(uid).get();
        final name = userDoc.data()?['name'] ?? '';

        final newUser = UserModel(
          uid: uid,
          email: _auth.currentUser?.email ?? '',
          role: 'jobseeker',
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

  // ── Upload Profile Image ───────────────────────────────
  Future<void> pickAndUploadImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null) return;

    isUploadingImage.value = true;
    try {
      final uid = _auth.currentUser!.uid;
      final file = File(picked.path);
      final fileName = 'profile_$uid.jpg';

      await _supabase.storage
          .from('profile-images')
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

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

  Future<void> pickAndUploadCover() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null) return;

    isUploadingCover.value = true;
    try {
      final uid = _auth.currentUser!.uid;
      final file = File(picked.path);
      final fileName = 'cover_$uid.jpg';

      await _supabase.storage
          .from('profile-images')
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

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

  // ── Add Education ─────────────────────────────────────
  Future<void> addEducation(EducationModel edu) async {
    final updated = [...education, edu];
    await _updateField('education', updated.map((e) => e.toMap()).toList());
    userModel.value = userModel.value?.copyWith(education: updated);
  }

  // ── Add Experience ────────────────────────────────────
  Future<void> addExperience(ExperienceModel exp) async {
    final updated = [...experience, exp];
    await _updateField('experience', updated.map((e) => e.toMap()).toList());
    userModel.value = userModel.value?.copyWith(experience: updated);
  }

  // ── Add Skill ─────────────────────────────────────────
  Future<void> addSkill(String skill) async {
    if (skill.trim().isEmpty) return;
    final updated = [...skills, skill.trim()];
    await _updateField('skills', updated);
    userModel.value = userModel.value?.copyWith(skills: updated);
  }

  // ── Remove Skill ──────────────────────────────────────
  Future<void> removeSkill(int index) async {
    final updated = [...skills]..removeAt(index);
    await _updateField('skills', updated);
    userModel.value = userModel.value?.copyWith(skills: updated);
  }

  // ── Dialogs ───────────────────────────────────────────
  void showAddEducationDialog() {
    final schoolCtrl = TextEditingController();
    final degreeCtrl = TextEditingController();
    final fieldCtrl = TextEditingController();
    final startCtrl = TextEditingController();
    final endCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Education'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _dialogField(schoolCtrl, 'School / University'),
              _dialogField(degreeCtrl, 'Degree'),
              _dialogField(fieldCtrl, 'Field of Study'),
              _dialogField(startCtrl, 'Start Year'),
              _dialogField(endCtrl, 'End Year'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (schoolCtrl.text.isNotEmpty) {
                addEducation(
                  EducationModel(
                    school: schoolCtrl.text,
                    degree: degreeCtrl.text,
                    field: fieldCtrl.text,
                    startYear: startCtrl.text,
                    endYear: endCtrl.text,
                  ),
                );
                Get.back();
              }
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

  void showAddExperienceDialog() {
    final companyCtrl = TextEditingController();
    final positionCtrl = TextEditingController();
    final startCtrl = TextEditingController();
    final endCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Experience'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _dialogField(companyCtrl, 'Company'),
              _dialogField(positionCtrl, 'Position'),
              _dialogField(startCtrl, 'Start Date'),
              _dialogField(endCtrl, 'End Date'),
              _dialogField(descCtrl, 'Description', maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (companyCtrl.text.isNotEmpty) {
                addExperience(
                  ExperienceModel(
                    company: companyCtrl.text,
                    position: positionCtrl.text,
                    startDate: startCtrl.text,
                    endDate: endCtrl.text,
                    description: descCtrl.text,
                  ),
                );
                Get.back();
              }
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

  void showAddSkillDialog() {
    final skillCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Add Skill'),
        content: _dialogField(skillCtrl, 'Skill name'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              addSkill(skillCtrl.text);
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

  // ── Logout ────────────────────────────────────────────
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.SPLASH);
  }

  // ── Private Helpers ───────────────────────────────────
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
