import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../application_review/model/application_review_model.dart';
import '../../application_review/model/job_with_application.dart';
import '../model/company_job_model.dart';

class ApplicationListController extends GetxController {
  final jobs = <JobWithApplicants>[].obs;
  final companyJobs = <CompanyJobModel>[].obs;
  final isLoading = true.obs;
  final isJobsLoading = true.obs;
  final jobsCount = 0.obs;
  final applicantsCount = 0.obs;
  final activeTab = 'applications'.obs;
  final selectedStatus = 'Pending'.obs;

  List<JobWithApplicants> get filteredJobs {
    return jobs
        .map((job) {
          final filtered = job.applicants.where((a) {
            if (selectedStatus.value == 'Pending') {
              return a.status != 'Accepted' && a.status != 'Rejected';
            }
            return a.status == selectedStatus.value;
          }).toList();
          return JobWithApplicants(
            jobId: job.jobId,
            jobTitle: job.jobTitle,
            applicants: filtered,
          );
        })
        .where((job) => job.applicants.isNotEmpty)
        .toList();
  }

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _appsCountByJob = <String, int>{};

  StreamSubscription? _appSub;
  StreamSubscription? _jobsSub;
  StreamSubscription? _jobsCountSub;
  StreamSubscription? _appsPerJobSub;

  @override
  void onInit() {
    super.onInit();
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      isLoading.value = false;
      isJobsLoading.value = false;
      return;
    }
    _listenToApplications(uid);
    _listenToCompanyJobs(uid);
    _listenToJobsCount(uid);
    _listenToAppsPerJobCount(uid);
  }

  void switchTab(String tab) {
    activeTab.value = tab;
  }

  void _listenToApplications(String companyId) {
    _appSub = _firestore
        .collection('applications')
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .listen(
          (snapshot) {
            if (isClosed) return;

            final docs = snapshot.docs;
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
                      updatedAt: data['updatedAt'] as String? ?? '',
                      applicantFcmToken: data['applicantFcmToken'] as String? ?? '',
                    ),
                  );
            }

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

  void _listenToCompanyJobs(String companyId) {
    _jobsSub = _firestore
        .collection('jobs')
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .listen(
          (snapshot) {
            if (isClosed) return;

            final loaded = snapshot.docs.map((doc) {
              final model = CompanyJobModel.fromMap(doc.id, doc.data());
              return CompanyJobModel(
                id: model.id,
                title: model.title,
                location: model.location,
                salary: model.salary,
                jobType: model.jobType,
                workMode: model.workMode,
                status: model.status,
                createdAt: model.createdAt,
                mainFieldName: model.mainFieldName,
                applicantCount: _appsCountByJob[doc.id] ?? 0,
              );
            }).toList();

            loaded.sort((a, b) {
              final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
              final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;
              return bTime.compareTo(aTime);
            });

            companyJobs.value = loaded;
            isJobsLoading.value = false;
          },
          onError: (e) {
            debugPrint('CompanyJobs stream error: $e');
            if (!isClosed) isJobsLoading.value = false;
          },
        );
  }

  void _listenToJobsCount(String companyId) {
    _jobsCountSub = _firestore
        .collection('jobs')
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .map((snap) => snap.docs.length)
        .listen((c) => jobsCount.value = c);
  }

  void _listenToAppsPerJobCount(String companyId) {
    _appsPerJobSub = _firestore
        .collection('applications')
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .listen((snap) {
          if (isClosed) return;
          _appsCountByJob.clear();
          for (final doc in snap.docs) {
            final jid = doc.data()['jobId'] as String? ?? '';
            _appsCountByJob[jid] = (_appsCountByJob[jid] ?? 0) + 1;
          }
          applicantsCount.value = snap.docs.length;
          // Rebuild company jobs with latest counts
          if (companyJobs.isNotEmpty) {
            companyJobs.value = companyJobs.map((job) {
              return CompanyJobModel(
                id: job.id,
                title: job.title,
                location: job.location,
                salary: job.salary,
                jobType: job.jobType,
                workMode: job.workMode,
                status: job.status,
                createdAt: job.createdAt,
                mainFieldName: job.mainFieldName,
                applicantCount: _appsCountByJob[job.id] ?? 0,
              );
            }).toList();
          }
        });
  }

  @override
  void onClose() {
    _appSub?.cancel();
    _jobsSub?.cancel();
    _jobsCountSub?.cancel();
    _appsPerJobSub?.cancel();
    super.onClose();
  }
}
