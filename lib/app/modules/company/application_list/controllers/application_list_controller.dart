import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/modules/company/application_list/views/widgets/app_confirm_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../application_review/model/application_review_model.dart';
import '../../application_review/model/job_with_application.dart';
import '../../company_main_wrapper/controllers/company_main_wrapper_controller.dart';
import '../../post_job/controllers/company_post_job_controller.dart';
import '../model/company_job_model.dart';

class ApplicationListController extends GetxController {
  final jobs = <JobWithApplicants>[].obs;
  final companyJobs = <CompanyJobModel>[].obs;

  final isLoading = true.obs;
  final isJobsLoading = true.obs;
  final isDeleting = false.obs;

  final jobsCount = 0.obs;
  final applicantsCount = 0.obs;

  final activeTab = 'jobs'.obs;
  final selectedStatus = 'Pending'.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  final _appsCountByJob = <String, int>{};

  StreamSubscription? _appSub;
  StreamSubscription? _jobsSub;
  StreamSubscription? _jobsCountSub;
  StreamSubscription? _appsPerJobSub;

  List<JobWithApplicants> get filteredJobs {
    return jobs
        .map((job) {
          final filtered = job.applicants.where((applicant) {
            final status = applicant.status.toLowerCase();

            if (selectedStatus.value == 'Pending') {
              return status != 'accepted' && status != 'rejected';
            }

            return status == selectedStatus.value.toLowerCase();
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

  void showJobsTab() {
    switchTab('jobs');
  }

  void showApplicationsTab() {
    switchTab('applications');
  }

  void _listenToApplications(String companyId) {
    _appSub = _firestore
        .collection('applications')
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .listen(
          (snapshot) {
            if (isClosed) return;

            final grouped = <String, List<ApplicationReviewModel>>{};
            final jobTitles = <String, String>{};

            for (final doc in snapshot.docs) {
              final data = doc.data();

              final jobId = data['jobId']?.toString() ?? '';
              final jobTitle = data['jobTitle']?.toString() ?? 'Unknown Job';

              if (jobId.isEmpty) continue;

              jobTitles[jobId] = jobTitle;

              grouped
                  .putIfAbsent(jobId, () => [])
                  .add(
                    ApplicationReviewModel(
                      id: doc.id,
                      jobSeekerId:
                          data['seekerId']?.toString() ??
                          data['applicantId']?.toString() ??
                          '',
                      name:
                          data['seekerName']?.toString() ??
                          data['applicantName']?.toString() ??
                          'Unknown',
                      jobTitle: jobTitle,
                      location: data['location']?.toString() ?? '',
                      email:
                          data['email']?.toString() ??
                          data['applicantEmail']?.toString() ??
                          '',
                      skills: data['skills']?.toString() ?? '',
                      experience: data['experience']?.toString() ?? '',
                      education: data['education']?.toString() ?? '',
                      cvUrl: data['cvUrl']?.toString() ?? '',
                      avatarUrl: data['avatarUrl']?.toString() ?? '',
                      status: data['status']?.toString() ?? 'Pending',
                      appliedAt: data['appliedAt']?.toString() ?? '',
                      updatedAt: data['updatedAt']?.toString() ?? '',
                      applicantFcmToken:
                          data['applicantFcmToken']?.toString() ?? '',
                      jobId: jobId,
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

            final loaded = snapshot.docs
                .map((doc) {
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
                    mainFieldId: model.mainFieldId,
                    mainFieldName: model.mainFieldName,
                    applicantCount: _appsCountByJob[doc.id] ?? 0,
                    minSalary: model.minSalary,
                    maxSalary: model.maxSalary,
                    description: model.description,
                    requirements: model.requirements,
                    isDeleted: model.isDeleted,
                  );
                })
                .where((job) => !job.isDeleted)
                .toList();

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
        .map((snapshot) {
          return snapshot.docs.where((doc) {
            final data = doc.data();
            return data['isDeleted'] != true;
          }).length;
        })
        .listen((jobCount) {
          jobsCount.value = jobCount;
        });
  }

  void _listenToAppsPerJobCount(String companyId) {
    _appsPerJobSub = _firestore
        .collection('applications')
        .where('companyId', isEqualTo: companyId)
        .snapshots()
        .listen((snapshot) {
          if (isClosed) return;

          _appsCountByJob.clear();

          for (final doc in snapshot.docs) {
            final jobId = doc.data()['jobId']?.toString() ?? '';

            if (jobId.isEmpty) continue;

            _appsCountByJob[jobId] = (_appsCountByJob[jobId] ?? 0) + 1;
          }

          applicantsCount.value = snapshot.docs.length;

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
                mainFieldId: job.mainFieldId,
                mainFieldName: job.mainFieldName,
                applicantCount: _appsCountByJob[job.id] ?? 0,
                minSalary: job.minSalary,
                maxSalary: job.maxSalary,
                description: job.description,
                requirements: job.requirements,
                isDeleted: job.isDeleted,
              );
            }).toList();
          }
        });
  }

  void editJob(CompanyJobModel job) {
    final postJobController = Get.isRegistered<CompanyPostJobController>()
        ? Get.find<CompanyPostJobController>()
        : Get.put(CompanyPostJobController());

    postJobController.loadJobForEdit(job);

    if (Get.isRegistered<CompanyMainWrapperController>()) {
      Get.find<CompanyMainWrapperController>().goToPostJob();
    }
  }

  Future<void> confirmCloseJob(CompanyJobModel job) async {
    final confirmed = await showAppConfirmDialog(
      icon: Icons.lock_outline_rounded,
      title: 'Close Job',
      message:
          'This job will be closed and hidden from job seekers, but applications will remain saved.',
      confirmText: 'Close',
      confirmColor: const Color(0xFFEF4444),
    );

    if (confirmed == true) {
      await closeJob(job.id);
    }
  }
  // void confirmCloseJob(CompanyJobModel job) {
  //   Get.defaultDialog(
  //     title: 'Close Job',
  //     middleText: 'Are you sure you want to close this job?',
  //     textCancel: 'Cancel',
  //     textConfirm: 'Close',
  //     confirmTextColor: Colors.white,
  //     buttonColor: const Color(0xFFEF4444),
  //     onConfirm: () async {
  //       Get.back();
  //       await closeJob(job.id);
  //     },
  //   );
  // }

  Future<void> closeJob(String jobId) async {
    try {
      await _firestore.collection('jobs').doc(jobId).update({
        'status': 'Closed',
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        'Success',
        'Job closed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to close job',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> confirmDeleteJob(CompanyJobModel job) async {
    final confirmed = await showAppConfirmDialog(
      icon: Icons.delete_outline_rounded,
      title: 'Delete Job',
      message:
          'This will permanently delete the job, all applications, related chats, and notifications. This action cannot be undone.',
      confirmText: 'Delete',
      confirmColor: const Color(0xFFEF4444),
    );

    if (confirmed == true) {
      await deleteJob(job.id);
    }
  }
  // void confirmDeleteJob(CompanyJobModel job) {
  //   Get.defaultDialog(
  //     title: 'Delete Job',
  //     middleText:
  //         'Are you sure you want to delete this job? This action will hide it from your jobs list.',
  //     textCancel: 'Cancel',
  //     textConfirm: 'Delete',
  //     confirmTextColor: Colors.white,
  //     buttonColor: const Color(0xFFEF4444),
  //     onConfirm: () async {
  //       Get.back();
  //       await deleteJob(job.id);
  //     },
  //   );
  // }

  Future<void> deleteJob(String jobId) async {
    try {
      isDeleting.value = true;

      // Step 1: Collect all applications for this job
      final appsSnapshot = await _firestore
          .collection('applications')
          .where('jobId', isEqualTo: jobId)
          .get();

      final seekerIds = <String>{};
      final appIds = <String>[];
      final cvUrls = <String>[];
      String? companyId;

      for (final doc in appsSnapshot.docs) {
        final data = doc.data();
        final seekerId = data['seekerId']?.toString() ?? '';
        if (seekerId.isNotEmpty) seekerIds.add(seekerId);
        appIds.add(doc.id);
        companyId ??= data['companyId']?.toString();
        final cvUrl = data['cvUrl']?.toString();
        if (cvUrl != null && cvUrl.isNotEmpty) cvUrls.add(cvUrl);
      }

      // Step 3: Collect savedJobs for this job
      final savedJobsSnapshot = await _firestore
          .collection('savedJobs')
          .where('jobId', isEqualTo: jobId)
          .get();

      // Step 4: Delete CV files from Supabase Storage
      if (cvUrls.isNotEmpty) {
        try {
          final cvPaths = cvUrls
              .map((url) => Uri.parse(url).pathSegments.last)
              .toList();
          await _supabase.storage.from('cv').remove(cvPaths);
        } catch (_) {
          // best-effort cleanup — don't block job deletion
        }
      }

      // Steps 2, 3, 6: Delete applications, savedJobs, and job document
      // using WriteBatch (split into batches of 500 if needed)
      final deletes = <void Function(WriteBatch)>[
        for (final appId in appIds)
          (b) => b.delete(_firestore.collection('applications').doc(appId)),
        for (final doc in savedJobsSnapshot.docs)
          (b) => b.delete(_firestore.collection('savedJobs').doc(doc.id)),
        (b) => b.delete(_firestore.collection('jobs').doc(jobId)),
      ];

      for (var i = 0; i < deletes.length; i += 500) {
        final batch = _firestore.batch();
        for (var j = i; j < (i + 500).clamp(0, deletes.length); j++) {
          deletes[j](batch);
        }
        await batch.commit();
      }

      // Step 5: Find and delete related chats from RTDB
      final db = FirebaseDatabase.instance.ref();
      if (companyId != null && companyId.isNotEmpty) {
        for (final seekerId in seekerIds) {
          final chatId = '${companyId}_$seekerId';
          final chatSnapshot = await db.child('chats/$chatId').get();
          if (chatSnapshot.exists) {
            await db.child('chats/$chatId/messages').remove();
            await db.child('chats/$chatId').remove();
          }
        }
      }

      // Delete notification docs related to the deleted applications
      final allUserIds = <String>{...seekerIds};
      if (companyId != null && companyId.isNotEmpty) {
        allUserIds.add(companyId);
      }

      for (final userId in allUserIds) {
        for (var i = 0; i < appIds.length; i += 10) {
          final chunk = appIds.skip(i).take(10).toList();
          if (chunk.isEmpty) continue;

          final notifSnapshot = await _firestore
              .collection('notifications')
              .doc(userId)
              .collection('items')
              .where('applicationId', whereIn: chunk)
              .get();

          if (notifSnapshot.docs.isEmpty) continue;

          final notifBatch = _firestore.batch();
          for (final doc in notifSnapshot.docs) {
            notifBatch.delete(doc.reference);
          }
          await notifBatch.commit();
        }
      }

      Get.snackbar(
        'Success',
        'Job deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete job: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isDeleting.value = false;
    }
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
// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../application_review/model/application_review_model.dart';
// import '../../application_review/model/job_with_application.dart';
// import '../model/company_job_model.dart';

// class ApplicationListController extends GetxController {
//   final jobs = <JobWithApplicants>[].obs;
//   final companyJobs = <CompanyJobModel>[].obs;
//   final isLoading = true.obs;
//   final isJobsLoading = true.obs;
//   final jobsCount = 0.obs;
//   final applicantsCount = 0.obs;
//   final activeTab = 'jobs'.obs;
//   final selectedStatus = 'Pending'.obs;

//   List<JobWithApplicants> get filteredJobs {
//     return jobs
//         .map((job) {
//           final filtered = job.applicants.where((a) {
//             if (selectedStatus.value == 'Pending') {
//               return a.status != 'Accepted' && a.status != 'Rejected';
//             }
//             return a.status == selectedStatus.value;
//           }).toList();
//           return JobWithApplicants(
//             jobId: job.jobId,
//             jobTitle: job.jobTitle,
//             applicants: filtered,
//           );
//         })
//         .where((job) => job.applicants.isNotEmpty)
//         .toList();
//   }

//   final _firestore = FirebaseFirestore.instance;
//   final _auth = FirebaseAuth.instance;
//   final _appsCountByJob = <String, int>{};

//   StreamSubscription? _appSub;
//   StreamSubscription? _jobsSub;
//   StreamSubscription? _jobsCountSub;
//   StreamSubscription? _appsPerJobSub;

//   @override
//   void onInit() {
//     super.onInit();
//     final uid = _auth.currentUser?.uid;
//     if (uid == null) {
//       isLoading.value = false;
//       isJobsLoading.value = false;
//       return;
//     }
//     _listenToApplications(uid);
//     _listenToCompanyJobs(uid);
//     _listenToJobsCount(uid);
//     _listenToAppsPerJobCount(uid);
//   }

//   void switchTab(String tab) {
//     activeTab.value = tab;
//   }

//   void showJobsTab() {
//     switchTab('jobs');
//   }

//   void showApplicationsTab() {
//     switchTab('applications');
//   }

//   void _listenToApplications(String companyId) {
//     _appSub = _firestore
//         .collection('applications')
//         .where('companyId', isEqualTo: companyId)
//         .snapshots()
//         .listen(
//           (snapshot) {
//             if (isClosed) return;

//             final docs = snapshot.docs;
//             final grouped = <String, List<ApplicationReviewModel>>{};
//             final jobTitles = <String, String>{};

//             for (final doc in docs) {
//               final data = doc.data();
//               final jobId = data['jobId'] as String? ?? '';
//               final jobTitle = data['jobTitle'] as String? ?? 'Unknown Job';

//               jobTitles[jobId] = jobTitle;

//               grouped
//                   .putIfAbsent(jobId, () => [])
//                   .add(
//                     ApplicationReviewModel(
//                       id: doc.id,
//                       jobSeekerId: data['seekerId'] as String? ?? '',
//                       name: data['seekerName'] as String? ?? 'Unknown',
//                       jobTitle: jobTitle,
//                       location: data['location'] as String? ?? '',
//                       email: data['email'] as String? ?? '',
//                       skills: data['skills'] as String? ?? '',
//                       experience: data['experience'] as String? ?? '',
//                       education: data['education'] as String? ?? '',
//                       cvUrl: data['cvUrl'] as String? ?? '',
//                       avatarUrl: data['avatarUrl'] as String? ?? '',
//                       status: data['status'] as String? ?? 'pending',
//                       appliedAt: data['appliedAt'] as String? ?? '',
//                       updatedAt: data['updatedAt'] as String? ?? '',
//                       applicantFcmToken:
//                           data['applicantFcmToken'] as String? ?? '',
//                     ),
//                   );
//             }

//             final result = grouped.entries.map((entry) {
//               return JobWithApplicants(
//                 jobId: entry.key,
//                 jobTitle: jobTitles[entry.key] ?? 'Unknown Job',
//                 applicants: entry.value,
//               );
//             }).toList();

//             jobs.value = result;
//             isLoading.value = false;
//           },
//           onError: (e) {
//             debugPrint('ApplicationList stream error: $e');
//             if (!isClosed) isLoading.value = false;
//           },
//         );
//   }

//   void _listenToCompanyJobs(String companyId) {
//     _jobsSub = _firestore
//         .collection('jobs')
//         .where('companyId', isEqualTo: companyId)
//         .snapshots()
//         .listen(
//           (snapshot) {
//             if (isClosed) return;

//             final loaded = snapshot.docs.map((doc) {
//               final model = CompanyJobModel.fromMap(doc.id, doc.data());
//               return CompanyJobModel(
//                 id: model.id,
//                 title: model.title,
//                 location: model.location,
//                 salary: model.salary,
//                 jobType: model.jobType,
//                 workMode: model.workMode,
//                 status: model.status,
//                 createdAt: model.createdAt,
//                 mainFieldName: model.mainFieldName,
//                 applicantCount: _appsCountByJob[doc.id] ?? 0,
//               );
//             }).toList();

//             loaded.sort((a, b) {
//               final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
//               final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;
//               return bTime.compareTo(aTime);
//             });

//             companyJobs.value = loaded;
//             isJobsLoading.value = false;
//           },
//           onError: (e) {
//             debugPrint('CompanyJobs stream error: $e');
//             if (!isClosed) isJobsLoading.value = false;
//           },
//         );
//   }

//   void _listenToJobsCount(String companyId) {
//     _jobsCountSub = _firestore
//         .collection('jobs')
//         .where('companyId', isEqualTo: companyId)
//         .snapshots()
//         .map((snap) => snap.docs.length)
//         .listen((c) => jobsCount.value = c);
//   }

//   void _listenToAppsPerJobCount(String companyId) {
//     _appsPerJobSub = _firestore
//         .collection('applications')
//         .where('companyId', isEqualTo: companyId)
//         .snapshots()
//         .listen((snap) {
//           if (isClosed) return;
//           _appsCountByJob.clear();
//           for (final doc in snap.docs) {
//             final jid = doc.data()['jobId'] as String? ?? '';
//             _appsCountByJob[jid] = (_appsCountByJob[jid] ?? 0) + 1;
//           }
//           applicantsCount.value = snap.docs.length;
//           // Rebuild company jobs with latest counts
//           if (companyJobs.isNotEmpty) {
//             companyJobs.value = companyJobs.map((job) {
//               return CompanyJobModel(
//                 id: job.id,
//                 title: job.title,
//                 location: job.location,
//                 salary: job.salary,
//                 jobType: job.jobType,
//                 workMode: job.workMode,
//                 status: job.status,
//                 createdAt: job.createdAt,
//                 mainFieldName: job.mainFieldName,
//                 applicantCount: _appsCountByJob[job.id] ?? 0,
//               );
//             }).toList();
//           }
//         });
//   }

//   @override
//   void onClose() {
//     _appSub?.cancel();
//     _jobsSub?.cancel();
//     _jobsCountSub?.cancel();
//     _appsPerJobSub?.cancel();
//     super.onClose();
//   }
// }
// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hire_me/app/modules/company/application_list/views/widgets/app_confirm_dialog.dart';

// import '../../application_review/model/application_review_model.dart';
// import '../../application_review/model/job_with_application.dart';
// import '../../company_main_wrapper/controllers/company_main_wrapper_controller.dart';
// import '../../post_job/controllers/company_post_job_controller.dart';
// import '../model/company_job_model.dart';

// class ApplicationListController extends GetxController {
//   final jobs = <JobWithApplicants>[].obs;
//   final companyJobs = <CompanyJobModel>[].obs;

//   final isLoading = true.obs;
//   final isJobsLoading = true.obs;
//   final isDeleting = false.obs;

//   final jobsCount = 0.obs;
//   final applicantsCount = 0.obs;

//   final activeTab = 'jobs'.obs;
//   final selectedStatus = 'Pending'.obs;

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   final _appsCountByJob = <String, int>{};

//   StreamSubscription? _appSub;
//   StreamSubscription? _jobsSub;
//   StreamSubscription? _jobsCountSub;
//   StreamSubscription? _appsPerJobSub;

//   List<JobWithApplicants> get filteredJobs {
//     return jobs
//         .map((job) {
//           final filtered = job.applicants.where((applicant) {
//             final status = applicant.status.toLowerCase();

//             if (selectedStatus.value == 'Pending') {
//               return status != 'accepted' && status != 'rejected';
//             }

//             return status == selectedStatus.value.toLowerCase();
//           }).toList();

//           return JobWithApplicants(
//             jobId: job.jobId,
//             jobTitle: job.jobTitle,
//             applicants: filtered,
//           );
//         })
//         .where((job) => job.applicants.isNotEmpty)
//         .toList();
//   }

//   @override
//   void onInit() {
//     super.onInit();

//     final uid = _auth.currentUser?.uid;

//     if (uid == null) {
//       isLoading.value = false;
//       isJobsLoading.value = false;
//       return;
//     }

//     _listenToApplications(uid);
//     _listenToCompanyJobs(uid);
//     _listenToJobsCount(uid);
//     _listenToAppsPerJobCount(uid);
//   }

//   void switchTab(String tab) {
//     activeTab.value = tab;
//   }

//   void showJobsTab() {
//     switchTab('jobs');
//   }

//   void showApplicationsTab() {
//     switchTab('applications');
//   }

//   void _listenToApplications(String companyId) {
//     _appSub = _firestore
//         .collection('applications')
//         .where('companyId', isEqualTo: companyId)
//         .snapshots()
//         .listen(
//           (snapshot) {
//             if (isClosed) return;

//             final grouped = <String, List<ApplicationReviewModel>>{};
//             final jobTitles = <String, String>{};

//             for (final doc in snapshot.docs) {
//               final data = doc.data();

//               if (data['isDeleted'] == true || data['jobDeleted'] == true) {
//                 continue;
//               }

//               final jobId = data['jobId']?.toString() ?? '';
//               final jobTitle = data['jobTitle']?.toString() ?? 'Unknown Job';

//               if (jobId.isEmpty) continue;

//               jobTitles[jobId] = jobTitle;

//               grouped
//                   .putIfAbsent(jobId, () => [])
//                   .add(
//                     ApplicationReviewModel(
//                       id: doc.id,
//                       jobSeekerId:
//                           data['seekerId']?.toString() ??
//                           data['applicantId']?.toString() ??
//                           '',
//                       name:
//                           data['seekerName']?.toString() ??
//                           data['applicantName']?.toString() ??
//                           'Unknown',
//                       jobTitle: jobTitle,
//                       location: data['location']?.toString() ?? '',
//                       email:
//                           data['email']?.toString() ??
//                           data['applicantEmail']?.toString() ??
//                           '',
//                       skills: data['skills']?.toString() ?? '',
//                       experience: data['experience']?.toString() ?? '',
//                       education: data['education']?.toString() ?? '',
//                       cvUrl: data['cvUrl']?.toString() ?? '',
//                       avatarUrl: data['avatarUrl']?.toString() ?? '',
//                       status: data['status']?.toString() ?? 'Pending',
//                       appliedAt: data['appliedAt']?.toString() ?? '',
//                       updatedAt: data['updatedAt']?.toString() ?? '',
//                       applicantFcmToken:
//                           data['applicantFcmToken']?.toString() ?? '',
//                       jobId: jobId,
//                     ),
//                   );
//             }

//             final result = grouped.entries.map((entry) {
//               return JobWithApplicants(
//                 jobId: entry.key,
//                 jobTitle: jobTitles[entry.key] ?? 'Unknown Job',
//                 applicants: entry.value,
//               );
//             }).toList();

//             jobs.value = result;
//             isLoading.value = false;
//           },
//           onError: (e) {
//             debugPrint('ApplicationList stream error: $e');
//             if (!isClosed) isLoading.value = false;
//           },
//         );
//   }

//   void _listenToCompanyJobs(String companyId) {
//     _jobsSub = _firestore
//         .collection('jobs')
//         .where('companyId', isEqualTo: companyId)
//         .snapshots()
//         .listen(
//           (snapshot) {
//             if (isClosed) return;

//             final loaded = snapshot.docs
//                 .map((doc) {
//                   final model = CompanyJobModel.fromMap(doc.id, doc.data());

//                   return CompanyJobModel(
//                     id: model.id,
//                     title: model.title,
//                     location: model.location,
//                     salary: model.salary,
//                     jobType: model.jobType,
//                     workMode: model.workMode,
//                     status: model.status,
//                     createdAt: model.createdAt,
//                     mainFieldId: model.mainFieldId,
//                     mainFieldName: model.mainFieldName,
//                     applicantCount: _appsCountByJob[doc.id] ?? 0,
//                     minSalary: model.minSalary,
//                     maxSalary: model.maxSalary,
//                     description: model.description,
//                     requirements: model.requirements,
//                     isDeleted: model.isDeleted,
//                   );
//                 })
//                 .where((job) => !job.isDeleted)
//                 .toList();

//             loaded.sort((a, b) {
//               final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
//               final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;

//               return bTime.compareTo(aTime);
//             });

//             companyJobs.value = loaded;
//             isJobsLoading.value = false;
//           },
//           onError: (e) {
//             debugPrint('CompanyJobs stream error: $e');
//             if (!isClosed) isJobsLoading.value = false;
//           },
//         );
//   }

//   void _listenToJobsCount(String companyId) {
//     _jobsCountSub = _firestore
//         .collection('jobs')
//         .where('companyId', isEqualTo: companyId)
//         .snapshots()
//         .map((snapshot) {
//           return snapshot.docs.where((doc) {
//             final data = doc.data();
//             return data['isDeleted'] != true;
//           }).length;
//         })
//         .listen((count) {
//           jobsCount.value = count;
//         });
//   }

//   void _listenToAppsPerJobCount(String companyId) {
//     _appsPerJobSub = _firestore
//         .collection('applications')
//         .where('companyId', isEqualTo: companyId)
//         .snapshots()
//         .listen((snapshot) {
//           if (isClosed) return;

//           _appsCountByJob.clear();

//           final activeApplications = snapshot.docs.where((doc) {
//             final data = doc.data();

//             return data['isDeleted'] != true && data['jobDeleted'] != true;
//           }).toList();

//           for (final doc in activeApplications) {
//             final jobId = doc.data()['jobId']?.toString() ?? '';

//             if (jobId.isEmpty) continue;

//             _appsCountByJob[jobId] = (_appsCountByJob[jobId] ?? 0) + 1;
//           }

//           applicantsCount.value = activeApplications.length;

//           if (companyJobs.isNotEmpty) {
//             companyJobs.value = companyJobs.map((job) {
//               return CompanyJobModel(
//                 id: job.id,
//                 title: job.title,
//                 location: job.location,
//                 salary: job.salary,
//                 jobType: job.jobType,
//                 workMode: job.workMode,
//                 status: job.status,
//                 createdAt: job.createdAt,
//                 mainFieldId: job.mainFieldId,
//                 mainFieldName: job.mainFieldName,
//                 applicantCount: _appsCountByJob[job.id] ?? 0,
//                 minSalary: job.minSalary,
//                 maxSalary: job.maxSalary,
//                 description: job.description,
//                 requirements: job.requirements,
//                 isDeleted: job.isDeleted,
//               );
//             }).toList();
//           }
//         });
//   }

//   void editJob(CompanyJobModel job) {
//     final postJobController = Get.isRegistered<CompanyPostJobController>()
//         ? Get.find<CompanyPostJobController>()
//         : Get.put(CompanyPostJobController());

//     postJobController.loadJobForEdit(job);

//     if (Get.isRegistered<CompanyMainWrapperController>()) {
//       Get.find<CompanyMainWrapperController>().goToPostJob();
//     }
//   }

//   Future<void> confirmCloseJob(CompanyJobModel job) async {
//     final confirmed = await showAppConfirmDialog(
//       icon: Icons.lock_outline_rounded,
//       title: 'Close Job',
//       message:
//           'This job will be closed and hidden from job seekers, but applications will remain saved.',
//       confirmText: 'Close',
//       confirmColor: const Color(0xFFEF4444),
//     );

//     if (confirmed == true) {
//       await closeJob(job.id);
//     }
//   }

//   Future<void> closeJob(String jobId) async {
//     try {
//       await _firestore.collection('jobs').doc(jobId).update({
//         'status': 'Closed',
//         'isActive': false,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       Get.snackbar(
//         'Success',
//         'Job closed successfully',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to close job',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   Future<void> confirmDeleteJob(CompanyJobModel job) async {
//     final confirmed = await showAppConfirmDialog(
//       icon: Icons.delete_outline_rounded,
//       title: 'Delete Job',
//       message:
//           'This will permanently delete the job, all applications, related chats, and notifications. This action cannot be undone.',
//       confirmText: 'Delete',
//       confirmColor: const Color(0xFFEF4444),
//     );

//     if (confirmed == true) {
//       await deleteJob(job.id);
//     }
//   }

//   Future<void> deleteJob(String jobId) async {
//     try {
//       isDeleting.value = true;

//       // Step 1: Collect all applications for this job
//       final appsSnapshot = await _firestore
//           .collection('applications')
//           .where('jobId', isEqualTo: jobId)
//           .get();

//       final seekerIds = <String>{};
//       final appIds = <String>[];
//       String? companyId;

//       for (final doc in appsSnapshot.docs) {
//         final data = doc.data();
//         final seekerId = data['seekerId']?.toString() ?? '';
//         if (seekerId.isNotEmpty) seekerIds.add(seekerId);
//         appIds.add(doc.id);
//         companyId ??= data['companyId']?.toString();
//       }

//       // Step 3: Collect savedJobs for this job
//       final savedJobsSnapshot = await _firestore
//           .collection('savedJobs')
//           .where('jobId', isEqualTo: jobId)
//           .get();

//       // Steps 2, 3, 6: Delete applications, savedJobs, and job document
//       // using WriteBatch (split into batches of 500 if needed)
//       final deletes = <void Function(WriteBatch)>[
//         for (final appId in appIds)
//           (b) => b.delete(_firestore.collection('applications').doc(appId)),
//         for (final doc in savedJobsSnapshot.docs)
//           (b) => b.delete(_firestore.collection('savedJobs').doc(doc.id)),
//         (b) => b.delete(_firestore.collection('jobs').doc(jobId)),
//       ];

//       for (var i = 0; i < deletes.length; i += 500) {
//         final batch = _firestore.batch();
//         for (var j = i; j < (i + 500).clamp(0, deletes.length); j++) {
//           deletes[j](batch);
//         }
//         await batch.commit();
//       }

//       // Step 5: Find and delete related chats from RTDB
//       final db = FirebaseDatabase.instance.ref();
//       if (companyId != null && companyId.isNotEmpty) {
//         for (final seekerId in seekerIds) {
//           final chatId = '${companyId}_$seekerId';
//           final chatSnapshot = await db.child('chats/$chatId').get();
//           if (chatSnapshot.exists) {
//             await db.child('chats/$chatId/messages').remove();
//             await db.child('chats/$chatId').remove();
//           }
//         }
//       }

//       // Delete notification docs related to the deleted applications
//       final allUserIds = <String>{...seekerIds};
//       if (companyId != null && companyId.isNotEmpty) {
//         allUserIds.add(companyId);
//       }

//       for (final userId in allUserIds) {
//         for (var i = 0; i < appIds.length; i += 10) {
//           final chunk = appIds.skip(i).take(10).toList();
//           if (chunk.isEmpty) continue;

//           final notifSnapshot = await _firestore
//               .collection('notifications')
//               .doc(userId)
//               .collection('items')
//               .where('applicationId', whereIn: chunk)
//               .get();

//           if (notifSnapshot.docs.isEmpty) continue;

//           final notifBatch = _firestore.batch();
//           for (final doc in notifSnapshot.docs) {
//             notifBatch.delete(doc.reference);
//           }
//           await notifBatch.commit();
//         }
//       }

//       for (final doc in applicationsSnapshot.docs) {
//         batch.update(doc.reference, {
//           'isDeleted': true,
//           'jobDeleted': true,
//           'updatedAt': FieldValue.serverTimestamp(),
//         });
//       }

//       await batch.commit();

//       Get.snackbar(
//         'Success',
//         'Job and related applications deleted successfully',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       debugPrint('Delete job error: $e');

//       Get.snackbar(
//         'Error',
//         'Failed to delete job: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isDeleting.value = false;
//     }
//   }

//   @override
//   void onClose() {
//     _appSub?.cancel();
//     _jobsSub?.cancel();
//     _jobsCountSub?.cancel();
//     _appsPerJobSub?.cancel();
//     super.onClose();
//   }
// }
