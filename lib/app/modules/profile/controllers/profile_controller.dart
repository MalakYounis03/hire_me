import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_pages.dart';
import 'package:hire_me/core/models/user_model.dart';

class ProfileController extends GetxController {
  final userModel = Rxn<UserModel>();
  final isLoading = false.obs;
  final isUploadingImage = false.obs;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  String get userName => userModel.value?.name ?? '';
  String get userTitle => userModel.value?.title ?? '';
  String get userUniversity => userModel.value?.university ?? '';
  String get userLocation => userModel.value?.location ?? '';
  String get userAbout => userModel.value?.about ?? '';
  String get userImage => userModel.value?.profileImage ?? '';
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

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null) return;

    isUploadingImage.value = true;
    try {
      final uid = _auth.currentUser!.uid;
      final file = File(picked.path);

      final ref = _storage.ref().child('profile_images/$uid.jpg');
      await ref.putFile(file);
      final imageUrl = await ref.getDownloadURL();

      await _updateField('profileImage', imageUrl);

      userModel.value = userModel.value?.copyWith(profileImage: imageUrl);
    } catch (e) {
      _showError('Failed to upload image');
    } finally {
      isUploadingImage.value = false;
    }
  }

  Future<void> addEducation(EducationModel edu) async {
    final updated = [...education, edu];
    await _updateField('education', updated.map((e) => e.toMap()).toList());
    userModel.value = userModel.value?.copyWith(education: updated);
  }

  Future<void> addExperience(ExperienceModel exp) async {
    final updated = [...experience, exp];
    await _updateField('experience', updated.map((e) => e.toMap()).toList());
    userModel.value = userModel.value?.copyWith(experience: updated);
  }

  Future<void> addSkill(String skill) async {
    if (skill.trim().isEmpty) return;
    final updated = [...skills, skill.trim()];
    await _updateField('skills', updated);
    userModel.value = userModel.value?.copyWith(skills: updated);
  }

  Future<void> removeSkill(int index) async {
    final updated = [...skills]..removeAt(index);
    await _updateField('skills', updated);
    userModel.value = userModel.value?.copyWith(skills: updated);
  }

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

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.SPLASH);
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

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
