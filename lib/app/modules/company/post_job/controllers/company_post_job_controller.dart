import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:hire_me/app/data/models/mainfield_model.dart';

class CompanyPostJobController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final minSalaryController = TextEditingController();
  final maxSalaryController = TextEditingController();
  final descriptionController = TextEditingController();
  final requirementsController = TextEditingController();

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _mainFieldsSubscription;

  final isLoading = false.obs;
  final isMainFieldsLoading = true.obs;
  final isUploadingLogo = false.obs;

  final mainFields = <MainFieldModel>[].obs;

  final selectedMainFieldId = ''.obs;
  final selectedMainFieldName = ''.obs;

  final selectedJobType = 'FullTime'.obs;
  final selectedWorkMode = 'Remote'.obs;

  final companyName = 'Company'.obs;
  final companyLogoUrl = ''.obs;

  final jobTypes = const ['Freelance', 'FullTime', 'PartTime'];

  final workModes = const ['Remote', 'Onsite', 'Hybrid'];

  @override
  void onInit() {
    super.onInit();
    loadCompanyData();
    listenToMainFields();
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

        companyName.value =
            data['companyName'] ??
            data['name'] ??
            data['fullName'] ??
            'Company';

        companyLogoUrl.value = data['logoUrl'] ?? data['profileImage'] ?? '';

        return;
      }

      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;

        companyName.value =
            data['companyName'] ??
            data['name'] ??
            data['fullName'] ??
            'Company';

        companyLogoUrl.value = data['logoUrl'] ?? data['profileImage'] ?? '';
      }
    } catch (_) {
      companyName.value = 'Company';
      companyLogoUrl.value = '';
    }
  }

  void listenToMainFields() {
    isMainFieldsLoading.value = true;

    _mainFieldsSubscription = _firestore
        .collection('mainFields')
        .snapshots()
        .listen(
          (snapshot) {
            final fields = snapshot.docs
                .map((doc) => MainFieldModel.fromMap(doc.id, doc.data()))
                .toList();

            mainFields.value = fields;

            if (fields.isNotEmpty && selectedMainFieldId.value.isEmpty) {
              selectedMainFieldId.value = fields.first.id;
              selectedMainFieldName.value = fields.first.name;
            }

            isMainFieldsLoading.value = false;
          },
          onError: (_) {
            isMainFieldsLoading.value = false;
            Get.snackbar('Error', 'Failed to load main fields');
          },
        );
  }

  void selectMainField(MainFieldModel field) {
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
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      Get.snackbar('Login Required', 'Please login first');
      return;
    }

    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (picked == null) return;

    try {
      isUploadingLogo.value = true;

      final file = File(picked.path);
      final fileName = 'company_logo_$uid.jpg';

      await _supabase.storage
          .from('logos')
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

      final publicUrl = _supabase.storage.from('logos').getPublicUrl(fileName);

      companyLogoUrl.value = publicUrl;

      await _firestore.collection('companies').doc(uid).set({
        'logoUrl': publicUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      Get.snackbar('Success', 'Company logo uploaded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload company logo: $e');
    } finally {
      isUploadingLogo.value = false;
    }
  }

  String get salaryValue {
    final min = minSalaryController.text.trim();
    final max = maxSalaryController.text.trim();

    if (min.isEmpty && max.isEmpty) return '';

    if (min.isNotEmpty && max.isNotEmpty) {
      return '\$$min-$max';
    }

    if (min.isNotEmpty) return '\$$min';
    return '\$$max';
  }

  Future<void> publishJob() async {
    if (isLoading.value) return;

    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      Get.snackbar('Login Required', 'Please login first');
      return;
    }

    if (!(formKey.currentState?.validate() ?? false)) return;

    if (selectedMainFieldId.value.isEmpty) {
      Get.snackbar('Required', 'Please select job category');
      return;
    }

    try {
      isLoading.value = true;

      await _firestore.collection('jobs').add({
        'companyId': uid,
        'companyName': companyName.value,
        'logoUrl': companyLogoUrl.value,

        'mainFieldId': selectedMainFieldId.value,
        'mainFieldName': selectedMainFieldName.value,

        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'requirements': requirementsController.text.trim(),

        'location': locationController.text.trim(),
        'salary': salaryValue,

        'jobType': selectedJobType.value,
        'workMode': selectedWorkMode.value,

        'status': 'Open',

        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      clearForm();

      Get.snackbar('Success', 'Job published successfully');

      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to publish job: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    titleController.clear();
    locationController.clear();
    minSalaryController.clear();
    maxSalaryController.clear();
    descriptionController.clear();
    requirementsController.clear();

    selectedJobType.value = 'FullTime';
    selectedWorkMode.value = 'Remote';

    if (mainFields.isNotEmpty) {
      selectedMainFieldId.value = mainFields.first.id;
      selectedMainFieldName.value = mainFields.first.name;
    }
  }

  String formatJobType(String value) {
    if (value == 'FullTime') return 'Full Time';
    if (value == 'PartTime') return 'Part Time';
    return value;
  }

  @override
  void onClose() {
    _mainFieldsSubscription?.cancel();

    titleController.dispose();
    locationController.dispose();
    minSalaryController.dispose();
    maxSalaryController.dispose();
    descriptionController.dispose();
    requirementsController.dispose();

    super.onClose();
  }
}
// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:hire_me/app/data/models/mainfield_model.dart';

// class CompanyPostJobController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   final formKey = GlobalKey<FormState>();

//   final titleController = TextEditingController();
//   final locationController = TextEditingController();
//   final minSalaryController = TextEditingController();
//   final maxSalaryController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final requirementsController = TextEditingController();

//   StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
//   _mainFieldsSubscription;

//   final isLoading = false.obs;
//   final isMainFieldsLoading = true.obs;

//   final mainFields = <MainFieldModel>[].obs;

//   final selectedMainFieldId = ''.obs;
//   final selectedMainFieldName = ''.obs;

//   final selectedJobType = 'FullTime'.obs;
//   final selectedWorkMode = 'Remote'.obs;

//   final companyName = 'Company'.obs;
//   final companyLogoUrl = ''.obs;

//   final jobTypes = const ['Freelance', 'FullTime', 'PartTime'];

//   final workModes = const ['Remote', 'Onsite', 'Hybrid'];

//   @override
//   void onInit() {
//     super.onInit();
//     loadCompanyData();
//     listenToMainFields();
//   }

//   Future<void> loadCompanyData() async {
//     try {
//       final uid = _auth.currentUser?.uid;

//       if (uid == null) return;

//       final companyDoc = await _firestore
//           .collection('companies')
//           .doc(uid)
//           .get();

//       if (companyDoc.exists && companyDoc.data() != null) {
//         final data = companyDoc.data()!;

//         companyName.value =
//             data['companyName'] ??
//             data['name'] ??
//             data['fullName'] ??
//             'Company';

//         companyLogoUrl.value = data['logoUrl'] ?? data['profileImage'] ?? '';

//         return;
//       }

//       final userDoc = await _firestore.collection('users').doc(uid).get();

//       if (userDoc.exists && userDoc.data() != null) {
//         final data = userDoc.data()!;

//         companyName.value =
//             data['companyName'] ??
//             data['name'] ??
//             data['fullName'] ??
//             'Company';

//         companyLogoUrl.value = data['logoUrl'] ?? data['profileImage'] ?? '';
//       }
//     } catch (_) {
//       companyName.value = 'Company';
//       companyLogoUrl.value = '';
//     }
//   }

//   void listenToMainFields() {
//     isMainFieldsLoading.value = true;

//     _mainFieldsSubscription = _firestore
//         .collection('mainFields')
//         .snapshots()
//         .listen(
//           (snapshot) {
//             final fields = snapshot.docs
//                 .map((doc) => MainFieldModel.fromMap(doc.id, doc.data()))
//                 .toList();

//             mainFields.value = fields;

//             if (fields.isNotEmpty && selectedMainFieldId.value.isEmpty) {
//               selectedMainFieldId.value = fields.first.id;
//               selectedMainFieldName.value = fields.first.name;
//             }

//             isMainFieldsLoading.value = false;
//           },
//           onError: (_) {
//             isMainFieldsLoading.value = false;
//             Get.snackbar('Error', 'Failed to load main fields');
//           },
//         );
//   }

//   void selectMainField(MainFieldModel field) {
//     selectedMainFieldId.value = field.id;
//     selectedMainFieldName.value = field.name;
//   }

//   void selectJobType(String value) {
//     selectedJobType.value = value;
//   }

//   void selectWorkMode(String value) {
//     selectedWorkMode.value = value;
//   }

//   String get salaryValue {
//     final min = minSalaryController.text.trim();
//     final max = maxSalaryController.text.trim();

//     if (min.isEmpty && max.isEmpty) return '';

//     if (min.isNotEmpty && max.isNotEmpty) {
//       return '\$$min-$max';
//     }

//     if (min.isNotEmpty) return '\$$min';
//     return '\$$max';
//   }

//   Future<void> publishJob() async {
//     if (isLoading.value) return;

//     final uid = _auth.currentUser?.uid;

//     if (uid == null) {
//       Get.snackbar('Login Required', 'Please login first');
//       return;
//     }

//     if (!(formKey.currentState?.validate() ?? false)) return;

//     if (selectedMainFieldId.value.isEmpty) {
//       Get.snackbar('Required', 'Please select job category');
//       return;
//     }

//     try {
//       isLoading.value = true;

//       await _firestore.collection('jobs').add({
//         'companyId': uid,
//         'companyName': companyName.value,
//         'logoUrl': companyLogoUrl.value,

//         'mainFieldId': selectedMainFieldId.value,
//         'mainFieldName': selectedMainFieldName.value,

//         'title': titleController.text.trim(),
//         'description': descriptionController.text.trim(),
//         'requirements': requirementsController.text.trim(),

//         'location': locationController.text.trim(),
//         'salary': salaryValue,

//         'jobType': selectedJobType.value,
//         'workMode': selectedWorkMode.value,

//         'status': 'Open',

//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       clearForm();

//       Get.snackbar('Success', 'Job published successfully');

//       Get.back();
//     } catch (_) {
//       Get.snackbar('Error', 'Failed to publish job');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void clearForm() {
//     titleController.clear();
//     locationController.clear();
//     minSalaryController.clear();
//     maxSalaryController.clear();
//     descriptionController.clear();
//     requirementsController.clear();

//     selectedJobType.value = 'FullTime';
//     selectedWorkMode.value = 'Remote';

//     if (mainFields.isNotEmpty) {
//       selectedMainFieldId.value = mainFields.first.id;
//       selectedMainFieldName.value = mainFields.first.name;
//     }
//   }

//   String formatJobType(String value) {
//     if (value == 'FullTime') return 'Full Time';
//     if (value == 'PartTime') return 'Part Time';
//     return value;
//   }

//   @override
//   void onClose() {
//     _mainFieldsSubscription?.cancel();

//     titleController.dispose();
//     locationController.dispose();
//     minSalaryController.dispose();
//     maxSalaryController.dispose();
//     descriptionController.dispose();
//     requirementsController.dispose();

//     super.onClose();
//   }
// }
