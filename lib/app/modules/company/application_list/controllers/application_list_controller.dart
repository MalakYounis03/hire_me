import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/modules/company/application_review/model/application_review_model.dart';
import 'package:hire_me/app/modules/company/application_review/model/job_with_application.dart';

class ApplicationListController extends GetxController {
  final jobs = <JobWithApplicants>[].obs;
  final isLoading = true.obs;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    _listenToApplications();
  }

  /// Streams pending applications for the current company from Firestore,
  /// grouped by job.
  void _listenToApplications() {
    final companyId = _auth.currentUser?.uid;
    if (companyId == null) {
      isLoading.value = false;
      return;
    }

    _firestore
        .collection('applications')
        .where('companyId', isEqualTo: companyId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen(
      (snapshot) {
        if (isClosed) return;

        final docs = snapshot.docs;

        // Group applications by jobId
        final grouped = <String, List<ApplicationReviewModel>>{};
        final jobTitles = <String, String>{};

        for (final doc in docs) {
          final data = doc.data();
          final jobId = data['jobId'] as String? ?? '';
          final jobTitle = data['jobTitle'] as String? ?? 'Unknown Job';

          jobTitles[jobId] = jobTitle;

          grouped.putIfAbsent(jobId, () => []).add(
            ApplicationReviewModel(
              id: doc.id,
              jobSeekerId: data['seekerId'] as String? ?? '',
              name: data['seekerName'] as String? ?? 'Unknown',
              jobTitle: jobTitle,
              location: data['location'] as String? ?? '',
              email: data['email'] as String? ?? '',
              skills: data['skills'] as String? ?? '',
              experience: data['experience'] as String? ?? '',
              education: data['education'] as String? ?? '',
              cvUrl: data['cvUrl'] as String? ?? '',
              avatarUrl: data['avatarUrl'] as String? ?? '',
              status: data['status'] as String? ?? 'pending',
              appliedAt: data['appliedAt'] as String? ?? '',
            ),
          );
        }

        // Build JobWithApplicants list
        final result = grouped.entries.map((entry) {
          return JobWithApplicants(
            jobId: entry.key,
            jobTitle: jobTitles[entry.key] ?? 'Unknown Job',
            applicants: entry.value,
          );
        }).toList();

        jobs.value = result;
        isLoading.value = false;
      },
      onError: (e) {
        debugPrint('ApplicationList stream error: $e');
        if (!isClosed) isLoading.value = false;
      },
    );
  }
}
