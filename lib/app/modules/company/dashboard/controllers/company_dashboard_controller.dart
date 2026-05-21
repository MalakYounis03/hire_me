import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CompanyDashboardController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _jobsSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _applicationsSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _notificationsSubscription;

  final isLoading = true.obs;

  final totalJobs = 0.obs;
  final unreadCount = 0.obs;
  final openJobs = 0.obs;
  final closedJobs = 0.obs;

  final totalApplicants = 0.obs;
  final acceptedApplicants = 0.obs;

  final recentJobs = <CompanyRecentJob>[].obs;
  final recentApplicants = <CompanyRecentApplicant>[].obs;

  final Map<String, int> _applicantsCountByJob = {};

  @override
  void onInit() {
    super.onInit();
    listenToCompanyDashboard();
  }

  void listenToCompanyDashboard() {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    _jobsSubscription?.cancel();
    _applicationsSubscription?.cancel();
    _notificationsSubscription?.cancel();

    _jobsSubscription = _firestore
        .collection('jobs')
        .where('companyId', isEqualTo: uid)
        .snapshots()
        .listen(
          (snapshot) {
            totalJobs.value = snapshot.docs.length;

            openJobs.value = snapshot.docs.where((doc) {
              final status =
                  doc.data()['status']?.toString().toLowerCase() ?? '';
              return status == 'open';
            }).length;

            closedJobs.value = snapshot.docs.where((doc) {
              final status =
                  doc.data()['status']?.toString().toLowerCase() ?? '';
              return status == 'closed';
            }).length;

            final jobs = snapshot.docs.map((doc) {
              final data = doc.data();

              return CompanyRecentJob(
                id: doc.id,
                title: data['title']?.toString() ?? 'Untitled Job',
                location: data['location']?.toString() ?? '',
                status: data['status']?.toString() ?? 'Open',
                applicantCount: _applicantsCountByJob[doc.id] ?? 0,
                createdAt: data['createdAt'],
              );
            }).toList();

            jobs.sort((a, b) {
              final aDate = a.createdAt is Timestamp
                  ? (a.createdAt as Timestamp).toDate()
                  : DateTime.fromMillisecondsSinceEpoch(0);

              final bDate = b.createdAt is Timestamp
                  ? (b.createdAt as Timestamp).toDate()
                  : DateTime.fromMillisecondsSinceEpoch(0);

              return bDate.compareTo(aDate);
            });

            recentJobs.value = jobs.take(3).toList();
            isLoading.value = false;
          },
          onError: (_) {
            isLoading.value = false;
          },
        );

    _applicationsSubscription = _firestore
        .collection('applications')
        .where('companyId', isEqualTo: uid)
        .snapshots()
        .listen(
          (snapshot) {
            totalApplicants.value = snapshot.docs.length;

            acceptedApplicants.value = snapshot.docs.where((doc) {
              final status =
                  doc.data()['status']?.toString().toLowerCase() ?? '';
              return status == 'accepted';
            }).length;

            _applicantsCountByJob.clear();

            for (final doc in snapshot.docs) {
              final jobId = doc.data()['jobId']?.toString() ?? '';
              if (jobId.isEmpty) continue;

              _applicantsCountByJob[jobId] =
                  (_applicantsCountByJob[jobId] ?? 0) + 1;
            }

            if (recentJobs.isNotEmpty) {
              recentJobs.value = recentJobs.map((job) {
                return CompanyRecentJob(
                  id: job.id,
                  title: job.title,
                  location: job.location,
                  status: job.status,
                  applicantCount: _applicantsCountByJob[job.id] ?? 0,
                  createdAt: job.createdAt,
                );
              }).toList();
            }

            final applicants = snapshot.docs.map((doc) {
              final data = doc.data();

              return CompanyRecentApplicant(
                id: doc.id,
                applicantName:
                    data['applicantName']?.toString() ??
                    data['seekerName']?.toString() ??
                    data['name']?.toString() ??
                    'Unknown Applicant',
                jobTitle:
                    data['jobTitle']?.toString() ??
                    data['title']?.toString() ??
                    'Unknown Job',
                location:
                    data['location']?.toString() ??
                    data['applicantLocation']?.toString() ??
                    'Palestine, Gaza',
                imageUrl:
                    data['applicantImage']?.toString() ??
                    data['imageUrl']?.toString() ??
                    data['profileImage']?.toString() ??
                    data['avatarUrl']?.toString() ??
                    '',
                createdAt: data['createdAt'],
              );
            }).toList();

            applicants.sort((a, b) {
              final aDate = a.createdAt is Timestamp
                  ? (a.createdAt as Timestamp).toDate()
                  : DateTime.fromMillisecondsSinceEpoch(0);

              final bDate = b.createdAt is Timestamp
                  ? (b.createdAt as Timestamp).toDate()
                  : DateTime.fromMillisecondsSinceEpoch(0);

              return bDate.compareTo(aDate);
            });

            recentApplicants.value = applicants.take(3).toList();
            isLoading.value = false;
          },
          onError: (_) {
            isLoading.value = false;
          },
        );

    _notificationsSubscription = _firestore
        .collection('notifications')
        .doc(uid)
        .collection('items')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .listen(
          (snapshot) => unreadCount.value = snapshot.docs.length,
          onError: (_) => unreadCount.value = 0,
        );
  }

  Future<void> refreshDashboard() async {
    listenToCompanyDashboard();
  }

  String formatDate(dynamic timestamp) {
    if (timestamp is! Timestamp) return '';

    final date = timestamp.toDate();
    final diff = DateTime.now().difference(date);

    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';

    return 'now';
  }

  @override
  void onClose() {
    _jobsSubscription?.cancel();
    _applicationsSubscription?.cancel();
    _notificationsSubscription?.cancel();
    super.onClose();
  }
}

class CompanyRecentJob {
  final String id;
  final String title;
  final String location;
  final String status;
  final int applicantCount;
  final dynamic createdAt;

  CompanyRecentJob({
    required this.id,
    required this.title,
    required this.location,
    required this.status,
    required this.applicantCount,
    required this.createdAt,
  });
}

class CompanyRecentApplicant {
  final String id;
  final String applicantName;
  final String jobTitle;
  final String location;
  final String imageUrl;
  final dynamic createdAt;

  CompanyRecentApplicant({
    required this.id,
    required this.applicantName,
    required this.jobTitle,
    required this.location,
    required this.imageUrl,
    required this.createdAt,
  });
} // import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';

// class CompanyDashboardController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _jobsSubscription;
//   StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
//   _applicationsSubscription;
//   StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
//   _notificationsSubscription;

//   final isLoading = true.obs;

//   final totalJobs = 0.obs;
//   final totalApplicants = 0.obs;
//   final acceptedApplicants = 0.obs;
//   final unreadCount = 0.obs;

//   final recentApplicants = <CompanyRecentApplicant>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     listenToCompanyDashboard();
//   }

//   void listenToCompanyDashboard() {
//     final uid = _auth.currentUser?.uid;

//     if (uid == null) {
//       isLoading.value = false;
//       return;
//     }

//     isLoading.value = true;

//     _jobsSubscription?.cancel();
//     _applicationsSubscription?.cancel();
//     _notificationsSubscription?.cancel();

//     _jobsSubscription = _firestore
//         .collection('jobs')
//         .where('companyId', isEqualTo: uid)
//         .snapshots()
//         .listen(
//           (snapshot) {
//             totalJobs.value = snapshot.docs.length;
//             isLoading.value = false;
//           },
//           onError: (_) {
//             isLoading.value = false;
//           },
//         );

//     _applicationsSubscription = _firestore
//         .collection('applications')
//         .where('companyId', isEqualTo: uid)
//         .snapshots()
//         .listen(
//           (snapshot) {
//             totalApplicants.value = snapshot.docs.length;

//             acceptedApplicants.value = snapshot.docs.where((doc) {
//               final status =
//                   doc.data()['status']?.toString().toLowerCase() ?? '';
//               return status == 'accepted';
//             }).length;

//             final applicants = snapshot.docs.map((doc) {
//               final data = doc.data();

//               return CompanyRecentApplicant(
//                 id: doc.id,
//                 applicantName:
//                     data['applicantName'] ??
//                     data['seekerName'] ??
//                     data['name'] ??
//                     'Unknown Applicant',
//                 jobTitle:
//                     data['jobTitle'] ??
//                     data['title'] ??
//                     data['jobName'] ??
//                     'Unknown Job',
//                 location:
//                     data['location'] ??
//                     data['applicantLocation'] ??
//                     data['city'] ??
//                     'Palestine, Gaza',
//                 imageUrl:
//                     data['applicantImage'] ??
//                     data['imageUrl'] ??
//                     data['profileImage'] ??
//                     '',
//                 createdAt: data['createdAt'],
//               );
//             }).toList();

//             applicants.sort((a, b) {
//               final aDate = a.createdAt is Timestamp
//                   ? (a.createdAt as Timestamp).toDate()
//                   : DateTime.fromMillisecondsSinceEpoch(0);

//               final bDate = b.createdAt is Timestamp
//                   ? (b.createdAt as Timestamp).toDate()
//                   : DateTime.fromMillisecondsSinceEpoch(0);

//               return bDate.compareTo(aDate);
//             });

//             recentApplicants.value = applicants.take(5).toList();
//             isLoading.value = false;
//           },
//           onError: (_) {
//             isLoading.value = false;
//           },
//         );

//     _notificationsSubscription = _firestore
//         .collection('notifications')
//         .doc(uid)
//         .collection('items')
//         .where('isRead', isEqualTo: false)
//         .snapshots()
//         .listen(
//           (snapshot) => unreadCount.value = snapshot.docs.length,
//           onError: (_) => unreadCount.value = 0,
//         );
//   }

//   Future<void> refreshDashboard() async {
//     listenToCompanyDashboard();
//   }

//   String formatDate(dynamic timestamp) {
//     if (timestamp is! Timestamp) return '';

//     final date = timestamp.toDate();
//     final diff = DateTime.now().difference(date);

//     if (diff.inDays > 0) return '${diff.inDays}d ago';
//     if (diff.inHours > 0) return '${diff.inHours}h ago';
//     if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';

//     return 'now';
//   }

//   @override
//   void onClose() {
//     _jobsSubscription?.cancel();
//     _applicationsSubscription?.cancel();
//     _notificationsSubscription?.cancel();
//     super.onClose();
//   }
// }

// class CompanyRecentApplicant {
//   final String id;
//   final String applicantName;
//   final String jobTitle;
//   final String location;
//   final String imageUrl;
//   final dynamic createdAt;

//   CompanyRecentApplicant({
//     required this.id,
//     required this.applicantName,
//     required this.jobTitle,
//     required this.location,
//     required this.imageUrl,
//     required this.createdAt,
//   });
// }
