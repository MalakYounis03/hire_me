// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../routes/app_pages.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class JobSeekerApplyJobController extends GetxController {
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();

//   final isLoading = false.obs;
//   final cvFileName = ''.obs;
//   final cvFilePath = ''.obs;

//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   final _supabase = Supabase.instance.client;

//   Map<String, dynamic> get job {
//     return Get.arguments as Map<String, dynamic>? ?? {};
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     final user = _auth.currentUser;
//     if (user != null) {
//       emailController.text = user.email ?? '';
//     }
//   }

//   Future<void> pickCV() async {
//     try {
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'doc', 'docx'],
//       );

//       if (result != null && result.files.isNotEmpty) {
//         cvFileName.value = result.files.single.name;
//         cvFilePath.value = result.files.single.path ?? '';
//       }
//     } catch (e) {
//       debugPrint('FilePicker error: $e');
//     }
//   }

//   Future<void> onApplyPressed() async {
//     if (nameController.text.trim().isEmpty) {
//       _showError('Please enter your full name');
//       return;
//     }
//     if (cvFilePath.value.isEmpty) {
//       _showError('Please upload your CV');
//       return;
//     }

//     isLoading.value = true;
//     try {
//       final uid = _auth.currentUser!.uid;
//       final file = File(cvFilePath.value);
//       final fileName =
//           '${uid}_${DateTime.now().millisecondsSinceEpoch}_${cvFileName.value}';

//       await _supabase.storage.from('cv').upload(fileName, file);

//       final cvUrl = _supabase.storage.from('cv').getPublicUrl(fileName);

//       await _firestore.collection('applications').add({
//         'jobId': job['id'] ?? '',
//         'jobTitle': job['title'] ?? '',
//         'companyId': job['companyId'] ?? '',
//         'companyName': job['company'] ?? '',
//         'applicantId': uid,
//         'applicantName': nameController.text.trim(),
//         'applicantEmail': emailController.text.trim(),
//         'cvUrl': cvUrl,
//         'status': 'pending',
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       Get.offNamed(Routes.JOB_SEEKER_CONGRATULATIONS);
//     } catch (e) {
//       _showError('Failed to apply: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void _showError(String message) {
//     Get.snackbar(
//       'Error',
//       message,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: const Color(0xFFEF4444),
//       colorText: Colors.white,
//       margin: const EdgeInsets.all(16),
//       borderRadius: 12,
//     );
//   }

//   @override
//   void onClose() {
//     nameController.dispose();
//     emailController.dispose();
//     super.onClose();
//   }
// }
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/modules/job_seeker/dashboard/models/job_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:hire_me/app/routes/app_pages.dart';

class JobSeekerApplyJobController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final isLoading = false.obs;
  final cvFileName = ''.obs;
  final cvFilePath = ''.obs;

  final Rxn<JobModel> job = Rxn<JobModel>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    _loadJobArgument();
    _loadCurrentUserData();
  }

  void _loadJobArgument() {
    final args = Get.arguments;

    if (args is JobModel) {
      job.value = args;
      return;
    }

    if (args is Map<String, dynamic>) {
      job.value = JobModel.fromMap(args['id']?.toString() ?? '', args);
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showError('Job data not found');

      Get.offAllNamed(Routes.MAIN_WRAPPER, arguments: {'initialIndex': 2});
    });
  }

  Future<void> _loadCurrentUserData() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) return;

    emailController.text = currentUser.email ?? '';

    try {
      final seekerDoc = await _firestore
          .collection('jobSeekers')
          .doc(currentUser.uid)
          .get();

      if (seekerDoc.exists && seekerDoc.data() != null) {
        final data = seekerDoc.data()!;

        nameController.text =
            data['fullName'] ?? data['name'] ?? currentUser.displayName ?? '';

        if (emailController.text.trim().isEmpty) {
          emailController.text = data['email'] ?? '';
        }

        return;
      }

      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;

        nameController.text =
            data['fullName'] ?? data['name'] ?? currentUser.displayName ?? '';

        if (emailController.text.trim().isEmpty) {
          emailController.text = data['email'] ?? '';
        }
      }
    } catch (e) {
      debugPrint('Failed to load user data: $e');
    }
  }

  Future<void> pickCV() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result == null || result.files.isEmpty) return;

      final pickedFile = result.files.single;

      if (pickedFile.path == null || pickedFile.path!.isEmpty) {
        _showError('Invalid CV file');
        return;
      }

      cvFileName.value = pickedFile.name;
      cvFilePath.value = pickedFile.path!;
    } catch (e) {
      debugPrint('FilePicker error: $e');
      _showError('Failed to pick CV');
    }
  }

  Future<void> onApplyPressed() async {
    final currentJob = job.value;
    final currentUser = _auth.currentUser;

    if (currentJob == null) {
      _showError('Job data not found');
      return;
    }

    if (currentUser == null) {
      _showError('Please login first');
      return;
    }

    if (nameController.text.trim().isEmpty) {
      _showError('Please enter your full name');
      return;
    }

    if (emailController.text.trim().isEmpty) {
      _showError('Please enter your email');
      return;
    }

    if (cvFilePath.value.isEmpty) {
      _showError('Please upload your CV');
      return;
    }

    if (currentJob.id.isEmpty) {
      _showError('Invalid job data');
      return;
    }

    final uid = currentUser.uid;

    try {
      final existingApplication = await _firestore
          .collection('applications')
          .where('applicantId', isEqualTo: uid)
          .where('jobId', isEqualTo: currentJob.id)
          .limit(1)
          .get();

      if (existingApplication.docs.isNotEmpty) {
        _showError('You have already applied to this job');
        return;
      }
    } catch (e) {
      _showError('Failed to check existing application');
      return;
    }

    final file = File(cvFilePath.value);

    if (!file.existsSync()) {
      _showError('CV file not found. Please upload again');
      return;
    }

    isLoading.value = true;

    try {
      final safeFileName = cvFileName.value.replaceAll(' ', '_');

      final fileName =
          '${uid}_${currentJob.id}_${DateTime.now().millisecondsSinceEpoch}_$safeFileName';

      await _supabase.storage
          .from('cv')
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

      final cvUrl = _supabase.storage.from('cv').getPublicUrl(fileName);

      await _firestore.collection('applications').add({
        'jobId': currentJob.id,
        'jobTitle': currentJob.title,
        'companyId': currentJob.companyId,
        'companyName': currentJob.companyName,
        'applicantId': uid,
        'seekerId': uid,
        'applicantName': nameController.text.trim(),
        'applicantEmail': emailController.text.trim(),
        'cvFileName': cvFileName.value,
        'cvUrl': cvUrl,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
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
