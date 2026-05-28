import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../application_list/model/company_job_model.dart';
import '../../company_main_wrapper/controllers/company_main_wrapper_controller.dart';

class CompanyPostJobController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final minSalaryController = TextEditingController();
  final maxSalaryController = TextEditingController();
  final descriptionController = TextEditingController();
  final requirementsController = TextEditingController();

  final isLoading = false.obs;
  final isUploadingLogo = false.obs;
  final isMainFieldsLoading = false.obs;

  final isEditMode = false.obs;
  final editingJobId = ''.obs;

  final companyLogoUrl = ''.obs;

  final mainFields = <CompanyMainField>[].obs;

  final selectedMainFieldId = ''.obs;
  final selectedMainFieldName = ''.obs;

  final selectedJobType = 'FullTime'.obs;
  final selectedWorkMode = 'Remote'.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SupabaseClient _supabase = Supabase.instance.client;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _mainFieldsSub;
  static const String _logoBucket = 'logos';
  String companyName = '';

  @override
  void onInit() {
    super.onInit();

    loadCompanyData();
    fetchMainFields();
  }

  Future<void> loadCompanyData() async {
    try {
      final uid = _auth.currentUser?.uid;

      if (uid == null) return;

      final companyDoc = await _firestore
          .collection('companies')
          .doc(uid)
          .get();

      if (companyDoc.exists && companyDoc.data() != null) {
        final data = companyDoc.data()!;

        companyName =
            data['companyName'] ??
            data['name'] ??
            data['fullName'] ??
            'Company';

        companyLogoUrl.value = data['logoUrl'] ?? data['companyLogoUrl'] ?? '';

        return;
      }

      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;

        companyName =
            data['companyName'] ??
            data['name'] ??
            data['fullName'] ??
            'Company';

        companyLogoUrl.value = data['logoUrl'] ?? data['companyLogoUrl'] ?? '';

        return;
      }

      companyName = _auth.currentUser?.displayName ?? 'Company';
    } catch (e) {
      debugPrint('Error loading company data: $e');
    }
  }

  void fetchMainFields() {
    try {
      isMainFieldsLoading.value = true;

      _mainFieldsSub?.cancel();

      _mainFieldsSub = _firestore
          .collection('mainFields')
          .snapshots()
          .listen(
            (snapshot) {
              final fields = snapshot.docs.map((doc) {
                return CompanyMainField.fromMap(id: doc.id, data: doc.data());
              }).toList();

              fields.sort((a, b) => a.name.compareTo(b.name));

              mainFields.value = fields;

              if (!isEditMode.value &&
                  fields.isNotEmpty &&
                  selectedMainFieldId.value.isEmpty) {
                selectMainField(fields.first);
              }

              isMainFieldsLoading.value = false;
            },
            onError: (e) {
              debugPrint('Error listening to main fields: $e');
              isMainFieldsLoading.value = false;
              _showError('Failed to load categories');
            },
          );
    } catch (e) {
      debugPrint('Error fetching main fields: $e');
      isMainFieldsLoading.value = false;
      _showError('Failed to load categories');
    }
  }

  void loadJobForEdit(CompanyJobModel job) {
    isEditMode.value = true;
    editingJobId.value = job.id;

    titleController.text = job.title;
    locationController.text = job.location;
    minSalaryController.text = job.minSalary?.toString() ?? '';
    maxSalaryController.text = job.maxSalary?.toString() ?? '';
    descriptionController.text = job.description;
    requirementsController.text = job.requirements;

    selectedMainFieldId.value = job.mainFieldId;
    selectedMainFieldName.value = job.mainFieldName;

    selectedJobType.value = job.jobType.isEmpty ? 'FullTime' : job.jobType;
    selectedWorkMode.value = job.workMode.isEmpty ? 'Remote' : job.workMode;
  }

  void resetCreateMode() {
    isEditMode.value = false;
    editingJobId.value = '';
    _clearForm();
  }

  void selectMainField(CompanyMainField field) {
    selectedMainFieldId.value = field.id;
    selectedMainFieldName.value = field.name;
  }

  void selectJobType(String value) {
    selectedJobType.value = value;
  }

  void selectWorkMode(String value) {
    selectedWorkMode.value = value;
  }

  Future<void> pickAndUploadCompanyLogo() async {
    try {
      final uid = _auth.currentUser?.uid;

      if (uid == null) {
        _showError('Please login first');
        return;
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;

      final pickedFile = result.files.single;

      if (pickedFile.path == null || pickedFile.path!.isEmpty) {
        _showError('Invalid image file');
        return;
      }

      isUploadingLogo.value = true;

      final file = File(pickedFile.path!);
      final extension = pickedFile.extension ?? 'jpg';

      final fileName =
          '${uid}_${DateTime.now().millisecondsSinceEpoch}.$extension';

      await _supabase.storage
          .from(_logoBucket)
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

      final imageUrl = _supabase.storage
          .from(_logoBucket)
          .getPublicUrl(fileName);

      companyLogoUrl.value = imageUrl;

      await _firestore.collection('companies').doc(uid).set({
        'logoUrl': imageUrl,
        'companyLogoUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Logo upload error: $e');
      _showError('Failed to upload company logo');
    } finally {
      isUploadingLogo.value = false;
    }
  }

  Future<void> submitJob() async {
    if (isEditMode.value) {
      await updateJob();
    } else {
      await publishJob();
    }
  }

  Future<void> publishJob() async {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      _showError('Please login first');
      return;
    }

    if (!(formKey.currentState?.validate() ?? false)) return;

    if (selectedMainFieldId.value.isEmpty ||
        selectedMainFieldName.value.isEmpty) {
      _showError('Please select category');
      return;
    }

    final minSalary = num.tryParse(minSalaryController.text.trim());
    final maxSalary = num.tryParse(maxSalaryController.text.trim());

    if (minSalary == null || maxSalary == null) {
      _showError('Please enter valid salary');
      return;
    }

    if (minSalary > maxSalary) {
      _showError('Min salary must be less than max salary');
      return;
    }

    isLoading.value = true;

    try {
      if (companyName.trim().isEmpty) {
        await loadCompanyData();
      }

      await _firestore.collection('jobs').add({
        'companyId': uid,
        'companyName': companyName.trim().isEmpty ? 'Company' : companyName,
        'companyLogoUrl': companyLogoUrl.value,
        'logoUrl': companyLogoUrl.value,
        'title': titleController.text.trim(),
        'mainFieldId': selectedMainFieldId.value,
        'mainFieldName': selectedMainFieldName.value,
        'category': selectedMainFieldName.value,
        'jobType': selectedJobType.value,
        'workMode': selectedWorkMode.value,
        'location': locationController.text.trim(),
        'minSalary': minSalary,
        'maxSalary': maxSalary,
        'salary': '\$${minSalary.toString()}-${maxSalary.toString()}',
        'description': descriptionController.text.trim(),
        'requirements': requirementsController.text.trim(),
        'status': 'Open',
        'isActive': true,
        'isDeleted': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _clearForm();

      Get.snackbar('Success', 'Job published successfully');

      if (Get.isRegistered<CompanyMainWrapperController>()) {
        Get.find<CompanyMainWrapperController>().goToDashboard();
      }
    } catch (e) {
      debugPrint('Publish job error: $e');
      _showError('Failed to publish job');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateJob() async {
    if (editingJobId.value.isEmpty) {
      _showError('Job data not found');
      return;
    }

    if (!(formKey.currentState?.validate() ?? false)) return;

    if (selectedMainFieldId.value.isEmpty ||
        selectedMainFieldName.value.isEmpty) {
      _showError('Please select category');
      return;
    }

    final minSalary = num.tryParse(minSalaryController.text.trim());
    final maxSalary = num.tryParse(maxSalaryController.text.trim());

    if (minSalary == null || maxSalary == null) {
      _showError('Please enter valid salary');
      return;
    }

    if (minSalary > maxSalary) {
      _showError('Min salary must be less than max salary');
      return;
    }

    isLoading.value = true;

    try {
      await _firestore.collection('jobs').doc(editingJobId.value).update({
        'title': titleController.text.trim(),
        'mainFieldId': selectedMainFieldId.value,
        'mainFieldName': selectedMainFieldName.value,
        'category': selectedMainFieldName.value,
        'jobType': selectedJobType.value,
        'workMode': selectedWorkMode.value,
        'location': locationController.text.trim(),
        'minSalary': minSalary,
        'maxSalary': maxSalary,
        'salary': '\$${minSalary.toString()}-${maxSalary.toString()}',
        'description': descriptionController.text.trim(),
        'requirements': requirementsController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      isEditMode.value = false;
      editingJobId.value = '';

      _clearForm();

      Get.snackbar('Success', 'Job updated successfully');

      if (Get.isRegistered<CompanyMainWrapperController>()) {
        Get.find<CompanyMainWrapperController>().changePage(0);
      }
    } catch (e) {
      debugPrint('Update job error: $e');
      _showError('Failed to update job');
    } finally {
      isLoading.value = false;
    }
  }

  void _clearForm() {
    titleController.clear();
    locationController.clear();
    minSalaryController.clear();
    maxSalaryController.clear();
    descriptionController.clear();
    requirementsController.clear();

    selectedJobType.value = 'FullTime';
    selectedWorkMode.value = 'Remote';

    if (mainFields.isNotEmpty) {
      selectMainField(mainFields.first);
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
    _mainFieldsSub?.cancel();

    titleController.dispose();
    locationController.dispose();
    minSalaryController.dispose();
    maxSalaryController.dispose();
    descriptionController.dispose();
    requirementsController.dispose();
    super.onClose();
  }
}

class CompanyMainField {
  final String id;
  final String name;
  final String iconUrl;

  CompanyMainField({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  factory CompanyMainField.fromMap({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return CompanyMainField(
      id: id,
      name: data['name'] ?? data['title'] ?? 'Unknown',
      iconUrl: data['iconUrl'] ?? data['imageUrl'] ?? '',
    );
  }
}
