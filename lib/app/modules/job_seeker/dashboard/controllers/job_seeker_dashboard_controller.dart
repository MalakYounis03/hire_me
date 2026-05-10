import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hire_me/app/data/models/job_model.dart';
import 'package:hire_me/app/data/models/mainfield_model.dart';

class JobSeekerDashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController searchTextController = TextEditingController();

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _jobsSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _mainFieldsSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _savedJobsSubscription;

  final userName = 'User'.obs;

  final allJobs = <JobModel>[].obs;
  final filteredJobs = <JobModel>[].obs;
  final mainFields = <MainFieldModel>[].obs;

final savedJobIds = <String>{}.obs;
final notificationBadgeCount = 0.obs;
  
  final isLoading = true.obs;
  final isMainFieldsLoading = true.obs;

  final searchQuery = ''.obs;
  final selectedMainFieldId = 'all'.obs;
  final selectedJobType = 'all'.obs;
  final selectedWorkMode = 'all'.obs;

  final jobTypes = const ['all', 'FullTime', 'PartTime', 'Freelance'];

  final workModes = const ['all', 'Onsite', 'Remote', 'Hybrid'];

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    listenToMainFields();
    listenToOpenJobs();
    listenToSavedJobs();
  }

  Future<void> fetchUserData() async {
    try {
      final uid = _auth.currentUser?.uid;

      if (uid == null) return;

      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        userName.value = userDoc.data()?['fullName'] ?? 'User';
        return;
      }

      final seekerDoc = await _firestore
          .collection('jobSeekers')
          .doc(uid)
          .get();

      if (seekerDoc.exists) {
        userName.value = seekerDoc.data()?['fullName'] ?? 'User';
      }
    } catch (_) {
      userName.value = 'User';
    }
  }

  void listenToMainFields() {
    isMainFieldsLoading.value = true;

    _mainFieldsSubscription = _firestore
        .collection('mainFields')
        .snapshots()
        .listen(
          (snapshot) {
            mainFields.value = snapshot.docs
                .map((doc) => MainFieldModel.fromMap(doc.id, doc.data()))
                .toList();

            isMainFieldsLoading.value = false;
          },
          onError: (_) {
            isMainFieldsLoading.value = false;
            Get.snackbar('Error', 'Failed to load main fields');
          },
        );
  }

  void listenToOpenJobs() {
    isLoading.value = true;

    _jobsSubscription = _firestore
        .collection('jobs')
        .where('status', isEqualTo: 'Open')
        .snapshots()
        .listen(
          (snapshot) {
            final jobs = snapshot.docs
                .map((doc) => JobModel.fromMap(doc.id, doc.data()))
                .toList();

            jobs.sort((a, b) {
              final aDate = a.createdAt?.toDate();
              final bDate = b.createdAt?.toDate();

              if (aDate == null && bDate == null) return 0;
              if (aDate == null) return 1;
              if (bDate == null) return -1;

              return bDate.compareTo(aDate);
            });

            allJobs.value = jobs;
            applyFilters();

            isLoading.value = false;
          },
          onError: (_) {
            isLoading.value = false;
            Get.snackbar('Error', 'Failed to load jobs');
          },
        );
  }

  void listenToSavedJobs() {
    final uid = _auth.currentUser?.uid;

    if (uid == null) return;

    _savedJobsSubscription = _firestore
        .collection('savedJobs')
        .where('seekerId', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
          savedJobIds.value = snapshot.docs
              .map((doc) => doc.data()['jobId']?.toString() ?? '')
              .where((id) => id.isNotEmpty)
              .toSet();
        });
  }

  void onSearch(String value) {
    searchQuery.value = value.trim();
    applyFilters();
  }

  void selectMainField(String fieldId) {
    selectedMainFieldId.value = fieldId;
    applyFilters();
  }

  void setJobTypeFilter(String value) {
    selectedJobType.value = value;
    applyFilters();
  }

  void setWorkModeFilter(String value) {
    selectedWorkMode.value = value;
    applyFilters();
  }

  void clearFilters() {
    selectedMainFieldId.value = 'all';
    selectedJobType.value = 'all';
    selectedWorkMode.value = 'all';
    searchQuery.value = '';
    searchTextController.clear();
    applyFilters();
  }

  void applyFilters() {
    Iterable<JobModel> results = allJobs;

    if (selectedMainFieldId.value != 'all') {
      results = results.where(
        (job) => job.mainFieldId == selectedMainFieldId.value,
      );
    }

    if (selectedJobType.value != 'all') {
      results = results.where((job) => job.jobType == selectedJobType.value);
    }

    if (selectedWorkMode.value != 'all') {
      results = results.where((job) => job.workMode == selectedWorkMode.value);
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();

      results = results.where((job) {
        return job.title.toLowerCase().contains(query) ||
            job.companyName.toLowerCase().contains(query) ||
            job.mainFieldName.toLowerCase().contains(query) ||
            job.location.toLowerCase().contains(query) ||
            job.description.toLowerCase().contains(query);
      });
    }

    filteredJobs.value = results.toList();
  }

  bool isJobSaved(String jobId) {
    return savedJobIds.contains(jobId);
  }

  Future<void> toggleSaveJob(String jobId) async {
    try {
      final uid = _auth.currentUser?.uid;

      if (uid == null) {
        Get.snackbar('Login Required', 'Please login to save jobs');
        return;
      }

      final savedJobDocId = '${uid}_$jobId';

      final savedJobRef = _firestore.collection('savedJobs').doc(savedJobDocId);

      if (isJobSaved(jobId)) {
        await savedJobRef.delete();
      } else {
        await savedJobRef.set({
          'seekerId': uid,
          'jobId': jobId,
          'savedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (_) {
      Get.snackbar('Error', 'Failed to update saved job');
    }
  }

  Future<void> refreshDashboard() async {
    await fetchUserData();
  }

  @override
  void onClose() {
    _jobsSubscription?.cancel();
    _mainFieldsSubscription?.cancel();
    _savedJobsSubscription?.cancel();
    searchTextController.dispose();
    super.onClose();
  }
}
