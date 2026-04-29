import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JobSeekerApplyJobController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final isLoading = false.obs;
  final cvFileName = ''.obs;
  final cvFilePath = ''.obs;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _supabase = Supabase.instance.client;

  Map<String, dynamic> get job {
    return Get.arguments as Map<String, dynamic>? ?? {};
  }

  @override
  void onInit() {
    super.onInit();
    final user = _auth.currentUser;
    if (user != null) {
      emailController.text = user.email ?? '';
    }
  }

  Future<void> pickCV() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.isNotEmpty) {
        cvFileName.value = result.files.single.name;
        cvFilePath.value = result.files.single.path ?? '';
      }
    } catch (e) {
      debugPrint('FilePicker error: $e');
    }
  }

  Future<void> onApplyPressed() async {
    if (nameController.text.trim().isEmpty) {
      _showError('Please enter your full name');
      return;
    }
    if (cvFilePath.value.isEmpty) {
      _showError('Please upload your CV');
      return;
    }

    isLoading.value = true;
    try {
      final uid = _auth.currentUser!.uid;
      final file = File(cvFilePath.value);
      final fileName =
          '${uid}_${DateTime.now().millisecondsSinceEpoch}_${cvFileName.value}';

      await _supabase.storage.from('cv').upload(fileName, file);

      final cvUrl = _supabase.storage.from('cv').getPublicUrl(fileName);

      await _firestore.collection('applications').add({
        'jobId': job['id'] ?? '',
        'jobTitle': job['title'] ?? '',
        'companyId': job['companyId'] ?? '',
        'companyName': job['company'] ?? '',
        'applicantId': uid,
        'applicantName': nameController.text.trim(),
        'applicantEmail': emailController.text.trim(),
        'cvUrl': cvUrl,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.offNamed(Routes.JOB_SEEKER_CONGRATULATIONS);
    } catch (e) {
      _showError('Failed to apply: $e');
    } finally {
      isLoading.value = false;
    }
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

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
